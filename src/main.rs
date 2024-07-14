// Steve Operating System
// Stephen Marz
// 21 Sep 2019
#![no_main]
#![no_std]

pub mod assembly;
pub mod rust_core;
pub mod uart;

use uart::Uart;


#[no_mangle]
extern "C" fn main() {
    // Main should initialize all sub-systems and get
    // ready to start scheduling. The last thing this
    // should do is start the timer.
	let my_uart = Uart::new(0x1000_0000);
    my_uart.init();

    println!("Hello World from RISC-V !");
    println!("Main ended. Ctrl+A X to terminate.");
}
