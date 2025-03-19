fn main() {
    println!("Hello, world!");
    // basic data type
    let x = 5;
    let y = x;
    println!("x is {}, y is {}", x, y);

    // String is stored in the heap
    let s1 = String::from("hello");
    let s2 = s1.clone() + ", world";
    let s3 = &s1;
    println!("s1 is {}, s2 is {}, s3 is {}", s1, s2, s3);
}
