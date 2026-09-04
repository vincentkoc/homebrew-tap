class Tokenjuice < Formula
  desc "Lean output compaction for terminal-heavy agent workflows"
  homepage "https://github.com/vincentkoc/tokenjuice"
  url "https://github.com/vincentkoc/tokenjuice/releases/download/v0.8.2/tokenjuice-v0.8.2.tar.gz"
  sha256 "25f950e7c8f516f4541b61c0788511fab7990eee4de91365b83fc755e4b9a9ea"
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
    assert_equal "0.8.2", shell_output("#{bin}/tokenjuice --version").strip
  end
end
