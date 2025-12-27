# Radiohead Vault - Rust Edition 🦀

This directory contains the Rust implementation, prioritizing memory safety and performance.

## 📋 Prerequisites

*   Rust (latest stable)
*   Cargo (included with Rust)

## 🛠️ Setup

1.  Navigate to this directory:
    ```bash
    cd rust
    ```
2.  Verify your installation:
    ```bash
    cargo --version
    ```
3.  Check dependencies (this will download `aes-gcm` and `rand`):
    ```bash
    cargo check
    ```

## 🚀 Usage

Run the project using Cargo:

```bash
cargo run
```

### Current Status
*   **Skeleton Implementation**: The current `main.rs` demonstrates the AES-GCM encryption primitives.
*   **Extending**: Modify `main.rs` to accept arguments using `std::env::args()` to match the Python implementation's CLI behavior.
