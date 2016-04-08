class Zoltan < Formula
  homepage "http://www.cs.sandia.gov/Zoltan"
  url "http://www.cs.sandia.gov/~kddevin/Zoltan_Distributions/zoltan_distrib_v3.81.tar.gz"
  sha256 "9d6f2f9e2b37456cab7fe6714d51cd6d613374e915e6cc9f7fddcd72e3f38780"

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on "origimbo/tools/petsc-fluidity"
  depends_on :fortran
  depends_on "gcc"

  mpilang = [:cc, :cxx, :f90]
  depends_on :mpi => mpilang


  fails_with :llvm 
  fails_with :clang
  fails_with :gcc_4_0
  fails_with :gcc do
    build 5666
    cause "need a recent version of gcc."
  end

  ENV["OMPI_FC"] = ENV["FC"]

  def oprefix(f)
    Formula[f].opt_prefix
  end

  def install
    ENV.deparallelize

    ENV["WRAPPER_DIR"] = "#{HOMEBREW_PREFIX}/Library/Taps/origimbo/homebrew-tools/wrappers"

    FileUtils.cp Dir["#{HOMEBREW_PREFIX}/Library/Taps/origimbo/homebrew-tools/wrappers/*"], Dir.getwd

    bin.install "mpicc-5"
    bin.install "mpicxx-5"

    ENV["CC"] = "#{bin}/mpicc-5"
    ENV["CXX"] = "#{bin}/mpicxx-5"

    args = [
      "--prefix=#{prefix}"
    ]
    args << "--with-parmetis" 
    args << "--enable-zoltan-cppdriver"
    args << "--enable-mpi"
    args << "--with-mpi-compilers=yes"
    args << "--with-gnumake"
    args << "--enable-zoltan-cppdriver"
    args << "--disable-examples"
    args << "--with-parmetis-libdir=#{oprefix("petsc-fluidity")}/lib/"
    args << "--with-parmetis-incdir=#{oprefix("petsc-fluidity")}/include"
    args << "--enable-f90interface"
    args << "FC=#{ENV["MPIFC"]}" 

    mkdir "zoltan-build" do
      system "../configure", *args
      system "make", "everything"
      system "make", "check" if build.with? "check"
      system "make", "install"
    end
  end

  test do
    system "true"
  end

end
