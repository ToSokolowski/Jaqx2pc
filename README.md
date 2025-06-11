# jaqx2pc

Batch exports `.xopp` files to `.pdf`.

## Nix Usage

This is the recommended way to run the tool, as it handles all dependencies automatically.

### Syntax

```bash
nix run github:jaqx2pc/xopp-exporter -- [options] <source> <destination>
```

#### Examples

```bash
# default
nix run github:jaqx2pc/xopp-exporter -- ./source_dir ./output_dir

# Verbose
nix run github:jaq

# Very verbose
nix run github:jaqx2pc/xopp-exporter -- -vv ./source_dir ./output_dir
```

## Standalone Usage

The `process.sh` could also be run directly.

Make sure the required dependencies are installed and in your `PATH`:

- `bash`
- `coreutils`
- `findutils`
- `xournalpp`

### Example

```bash
chmod +x process.sh
./process.sh -v ./source_dir ./output_dir
```
