class Tokenjuice < Formula
  desc "Lean output compaction for terminal-heavy agent workflows"
  homepage "https://github.com/vincentkoc/tokenjuice"
  url "https://github.com/vincentkoc/tokenjuice/releases/download/v0.11.2/tokenjuice-v0.11.2.tar.gz"
  sha256 "82eac846cd664ae279b0b4c4ecaf1449064b80c94b01be84b7613d63d05db523"
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
    assert_equal "0.11.2", shell_output("#{bin}/tokenjuice --version").strip
  end
end
