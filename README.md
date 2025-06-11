# jaqx2pc

Batch exports `.xopp` files to `.pdf`.

## Nix Usage

This is the recommended way to run the tool, as it handles all dependencies automatically.

### Syntax

```bash
nix run github:ToSokolowski/jaqx2pc -- [options] <source> <destination>
```

#### Examples

```bash
# default
nix run github:ToSokolowski/jaqx2pc -- ./source_dir ./output_dir

# Verbose
nix run github:ToSokolowski/jaqx2pc -- -vv ./source_dir ./output_dir

# Very verbose
nix run github:ToSokolowski/jaqx2pc -- -vv ./source_dir ./output_dir
```

## Standalone Usage

The `process.sh` could also be run directly.

Make sure the required dependencies are installed and in your `PATH`:

- `bash`
- `coreutils` or alternatives, providing `ls mkdir realpath wc`
- `findutils` or alternatives, providing `find`
- `xournalpp`

### Usage

First, clone the repository to get the `process.sh` locally, and make the script executable:

```bash
git clone https://github.com/ToSokolowski/jaqx2pc.git
cd xopp-exporter
chmod +x process.sh

```

Then run the shell script like that:

```bash
./process.sh [options] <source> <destination>
```

Alternativly (but not recommended) the script can be run via curl directly from the terminal with the following command:
```bash
curl -Ls https://raw.githubusercontent.com/ToSokolowski/jaqx2pc/main/process.sh | bash -s [options] <source> <destination>
```
