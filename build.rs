//! Copies non-.typ files from the src directory into the build directory,
//! then compiles the .typ files into it with `typst compile`.

use std::env;
use std::fs;
use std::io;
use std::path::Path;
use std::process::Command;

fn copy_non_typ_files(src: &Path, dst: &Path) -> io::Result<()> {
    fs::create_dir_all(dst)?;

    for entry in fs::read_dir(src)? {
        let entry = entry?;
        let path = entry.path();
        let dest_path = dst.join(entry.file_name());

        if path.is_dir() {
            copy_non_typ_files(&path, &dest_path)?;
        } else if path.extension().and_then(|ext| ext.to_str()) != Some("typ") {
            fs::copy(&path, &dest_path)?;
        }
    }

    Ok(())
}

fn main() {
    let args: Vec<String> = env::args().collect();
    let src_dir = args.get(1).cloned().unwrap_or_else(|| "src".to_string());
    let build_dir = args.get(2).cloned().unwrap_or_else(|| "_build".to_string());

    copy_non_typ_files(Path::new(&src_dir), Path::new(&build_dir))
        .expect("failed to copy non-.typ files into build directory");

    let main_typ = Path::new(&src_dir).join("main.typ");
    let status = Command::new("typst")
        .args(["compile", "--features", "bundle,html", "--format", "bundle"])
        .arg(&main_typ)
        .arg(&build_dir)
        .status()
        .expect("failed to run typst compile");

    if !status.success() {
        std::process::exit(status.code().unwrap_or(1));
    }

    println!("Build succeeded: {} -> {}", src_dir, build_dir);
}
