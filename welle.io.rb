class WelleIo < Formula
  desc "DAB/DAB+ Software Radio"
  homepage "https://www.welle.io"
  url "https://github.com/AlbrechtL/welle.io/archive/V20170826.tar.gz"
  sha256 "21c65ac35c041d7e1dd1fa609c24c43e01c591fcdfb85369a8229d16a9103a3b"

  depends_on "cmake" => :build
  depends_on "qt"
  depends_on "fftw"
  depends_on "faad2"
  depends_on "librtlsdr"
  depends_on "libusb"

  def install
    system "cmake", ".", "-DRTLSDR=TRUE", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/welle-io", "-v"
  end
end
