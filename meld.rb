class Meld < Formula
  desc "visual diff and merge tool targeted at developers"
  homepage "http://meldmerge.org"
  url "https://download.gnome.org/sources/meld/3.16/meld-3.16.4.tar.xz"
  sha256 "93c4f928319dae7484135ab292fe6ea4254123e8219549a66d3e2deba6a38e67"

  depends_on "intltool" => :build
  depends_on "itstool" => :build
  depends_on "python"
  depends_on "gtk+" # gtk-update-icon-cache is currently missing in gtk+3
  depends_on "gtk+3"
  depends_on "glib"
  depends_on "pygobject3"
  depends_on "gtksourceview3"

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}"
  end

  test do
    system "#{bin}/meld", "--help"
  end
end
