wit_bindgen::generate!({
    // the name of the world in the `*.wit` input file
    world: "host",
});


struct MyHost;

impl Guest for MyHost {
    fn run() {}
}

// export! defines that the `MyHost` struct defined below is going to define
// the exports of the `world`, namely the `run` function.
export!(MyHost);
