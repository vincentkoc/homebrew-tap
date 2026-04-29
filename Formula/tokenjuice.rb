class Tokenjuice < Formula
  desc "Lean output compaction for terminal-heavy agent workflows"
  homepage "https://github.com/vincentkoc/tokenjuice"
  url "https://github.com/vincentkoc/tokenjuice/releases/download/v0.6.6/tokenjuice-v0.6.6.tar.gz"
  sha256 "f48217e247c5ec3ab737e73c326dfe8c3574332c3936c193ad33f2942cf2234c"
  license "MIT"
  version "0.6.6"

  depends_on "node"

  def install
    libexec.install "dist", "package.json", "README.md", "LICENSE"

    (bin/"tokenjuice").write <<~EOS
      #!/bin/bash
      exec "#{Formula["node"].opt_bin}/node" "#{libexec}/dist/cli/main.js" "$@"
    EOS
    (bin/"tokenjuice").chmod 0755
  end

  test do
    assert_equal "0.6.6", shell_output("#{bin}/tokenjuice --version").strip
  end
end
