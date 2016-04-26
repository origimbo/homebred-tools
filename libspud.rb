# Documentation: https://github.com/Homebrew/homebrew/blob/master/share/doc/homebrew/Formula-Cookbook.md
#                http://www.rubydoc.info/github/Homebrew/homebrew/master/Formula
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Libspud < Formula
  desc ""
  homepage ""
  url "lp:spud", :using => :bzr
  sha256 ""
  version "1.1"

  # depends_on "cmake" => :build
  depends_on "libxml2"
  depends_on "python"
  depends_on "trang"
  depends_on "pygtk" => "with-libglade"
  depends_on :fortran

  bottle do
    root_url "https://github.com/origimbo/homebrew-tools/releases/download/v2.1/" 
    cellar :any_skip_relocation
    sha256 "caec3fe5d64de3500520d86d8460aec1002dc284a42b1066b8e47d566701105d" => :mavericks
  end

  env :std

  fails_with :llvm 

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install" # if this fails, try separate make/make install steps

    inreplace "#{bin}/diamond", "/usr/share/diamond/gui/diamond.svg", "#{prefix}/share/diamond/gui/diamond.svg"

  end

  test do
    system "true"
  end
end
