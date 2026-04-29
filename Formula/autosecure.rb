class Autosecure < Formula
  desc "Block known bad IPs from threat feeds using iptables"
  homepage "https://github.com/vincentkoc/autosecure"
  url "https://github.com/vincentkoc/autosecure/releases/download/v2.3.4/autosecure-v2.3.4.tar.gz"
  sha256 "e0b14fc072661acb5a9a6fc29969d0422f23671dbe5941bb7a3ed981c0350fae"
  license "GPL-3.0"
  version "2.3.4"

  depends_on "bash"

  def install
    bin.install "autosecure.sh" => "autosecure"
    doc.install "README.md", "LICENSE.md"
  end
end
