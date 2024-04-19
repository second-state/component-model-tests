# http

## commands

```shell
# compile wat to wasm
wasm-tools parse http.wat -o http.wasm
```

## Memory

Refers https://github.com/bytecodealliance/wasmtime/blob/main/crates/component-util/src/lib.rs for memory trick.
 
## Explanation

```wasm
(component
  ;; memory stuff
  (core module $Libc
    (memory (export "mem") 1)
    (global $last (mut i32) (i32.const 8))
    (func $realloc (export "realloc")
        (param $old_ptr i32)
        (param $old_size i32)
        (param $align i32)
        (param $new_size i32)
        (result i32)

        (local $ret i32)

        ;; Test if the old pointer is non-null
        local.get $old_ptr
        if
            ;; If the old size is bigger than the new size then
            ;; this is a shrink and transparently allow it
            local.get $old_size
            local.get $new_size
            i32.gt_u
            if
                local.get $old_ptr
                return
            end

            ;; otherwise fall through to allocate a new chunk which will later
            ;; copy data over
        end

        ;; align up `$last`
        (global.set $last
            (i32.and
                (i32.add
                    (global.get $last)
                    (i32.add
                        (local.get $align)
                        (i32.const -1)))
                (i32.xor
                    (i32.add
                        (local.get $align)
                        (i32.const -1))
                    (i32.const -1))))

        ;; save the current value of `$last` as the return value
        global.get $last
        local.set $ret

        ;; bump our pointer
        (global.set $last
            (i32.add
                (global.get $last)
                (local.get $new_size)))

        ;; while `memory.size` is less than `$last`, grow memory
        ;; by one page
        (loop $loop
            (if
                (i32.lt_u
                    (i32.mul (memory.size) (i32.const 65536))
                    (global.get $last))
                (then
                    i32.const 1
                    memory.grow
                    ;; test to make sure growth succeeded
                    i32.const -1
                    i32.eq
                    if unreachable end

                    br $loop)))


        ;; ensure anything necessary is set to valid data by spraying a bit
        ;; pattern that is invalid
        local.get $ret
        i32.const 0xde
        local.get $new_size
        memory.fill

        ;; If the old pointer is present then that means this was a reallocation
        ;; of an existing chunk which means the existing data must be copied.
        local.get $old_ptr
        if
            local.get $ret          ;; destination
            local.get $old_ptr      ;; source
            local.get $old_size     ;; size
            memory.copy
        end

        local.get $ret
    )
  )
  (core instance $libc (instantiate $Libc))

  (import "wasi:http/test" (instance $http
    (export "http-get" (func (param "uri" string) (result string)))
    (export "print" (func (param "text" string)))
  ))

  (core func $http-get (canon lower
    (func $http "http-get")
    (memory $libc "mem")
    (realloc (func $libc "realloc"))
  ))
  (core func $print (canon lower
    (func $http "print")
    (memory $libc "mem")
    (realloc (func $libc "realloc"))
  ))

  (core module $M
    (import "libc" "mem" (memory 1))
    (import "libc" "realloc" (func (param i32 i32 i32 i32) (result i32)))
    (func $get (import "http" "http-get") (param i32 i32) (result i32 i32))
    (func $print (import "http" "print") (param i32 i32))

    (func (export "run") (param i32 i32)
      local.get 0
      local.get 1
      call $get
      call $print
    )
  )

  (core instance $main
    (instantiate $M
      (with "libc" (instance $libc))
      (with "http"
        (instance
          (export "http-get" (func $http-get))
          (export "print" (func $print))
        )
      )
    )
  )

  (func $run (param "uri" string)
    (canon lift
      (core func $main "run")
      (memory $libc "mem")
      (realloc (func $libc "realloc"))
    )
  )
  (export "run" (func $run))
)
```

The file defines a component, where have

1. A core module `Libc` that has a memory, we are going to pass data via share this memory
2. instantiate `libc` as a core instance
3. Imports a component `wasi:http/test`, such that have two functions
4. Lowering two functions
5. A core module `M`
6. Instantiate the core module `M`, named instance `main`, with two lowering functions as immediate core instance
7. Canonical lift a core function `run` from instance `main` to be a component function
    - it's cool that we can use `string` here
8. Export the component function

When one executes the component (refers [docker](../docker#run-the-wasi-http-demo), result `run uri` is do http get via URL `uri`, and print the content.
