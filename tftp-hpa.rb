class TftpHpa < Formula
  desc "BSD TFTP code (client and server) maintained by H. Peter Anvin"
  homepage "https://www.kernel.org/pub/software/network/tftp/tftp-hpa/"
  url "https://www.kernel.org/pub/software/network/tftp/tftp-hpa/tftp-hpa-5.2.tar.bz2"
  sha256 "0a9f88d4c1c02687b4853b02ab5dd8779d4de4ffdb9b2e5c9332841304d1a269"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-ipv6"
    system "make"
    system "make", "install"
  end

  test do
    system "#{sbin}/in.tftpd", "-V"
    system "#{bin}/tftp", "-V"
  end
end
