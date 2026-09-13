class Tokenjuice < Formula
  desc "Lean output compaction for terminal-heavy agent workflows"
  homepage "https://github.com/vincentkoc/tokenjuice"
  url "https://github.com/vincentkoc/tokenjuice/releases/download/v0.8.4/tokenjuice-v0.8.4.tar.gz"
  sha256 "3c782f81659dcf22b6287523b8efb292523e1a9d78895f715cdace2f5d9fb858"
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
    assert_equal "0.8.4", shell_output("#{bin}/tokenjuice --version").strip
  end
end
