class Tokenjuice < Formula
  desc "Lean output compaction for terminal-heavy agent workflows"
  homepage "https://github.com/vincentkoc/tokenjuice"
  url "https://github.com/vincentkoc/tokenjuice/releases/download/v0.11.1/tokenjuice-v0.11.1.tar.gz"
  sha256 "7222e927057b58eac0a6471d5f9475f7832f9c8ec6a474cc7da20c1eecde4f76"
  license "MIT"

  depends_on "node"

  def install
    libexec.install "dist", "package.json", "README.md", "LICENSE"

    (bin/"tokenjuice").write <<~EOS
      #!/bin/bash
      exec "#{formula_opt_bin("node")}/node" "#{libexec}/dist/cli/main.js" "$@"
    EOS
    (bin/"tokenjuice").chmod 0755
  end

  test do
    assert_equal "0.11.1", shell_output("#{bin}/tokenjuice --version").strip
  end
end
