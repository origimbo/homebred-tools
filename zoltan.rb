class Zoltan < Formula
  homepage "http://www.cs.sandia.gov/Zoltan"
  url "http://www.cs.sandia.gov/~kddevin/Zoltan_Distributions/zoltan_distrib_v3.81.tar.gz"
  sha256 "9d6f2f9e2b37456cab7fe6714d51cd6d613374e915e6cc9f7fddcd72e3f38780"

  option "without-check", "Skip build-time tests (not recommended)"

  depends_on 'parmetis'
  depends_on :fortran

  mpilang = [:cc, :cxx, :f90]
  depends_on :mpi => mpilang

  fails_with :llvm 
  fails_with :gcc_4_0

  ENV["OMPI_FC"] = ENV["FC"]

  def oprefix(f)
    Formula[f].opt_prefix
  end

  def install
    ENV.deparallelize

    args = [
      "--prefix=#{prefix}",
      "CC=#{ENV["MPICC"]}",
      "CXX=#{ENV["MPICXX"]}",
    ]
    args << "--with-parmetis" 
    args << "--enable-zoltan-cppdriver"
    args << "--enable-mpi"
    args << "--with-mpi-compilers=yes"
    args << "--with-gnumake"
    args << "--enable-zoltan-cppdriver"
    args << "--disable-examples"
    args << "--with-parmetis-libdir=#{oprefix("parmetis")}/lib/"
    args << "--with-parmetis-incdir=#{oprefix("parmetis")}/include"
    args << "--enable-f90interface"
    args << "FC=#{ENV["MPIFC"]}" 

    mkdir "zoltan-build" do
      system "../configure", *args
      system "make", "everything"
      system "make", "check" if build.with? "check"
      system "make", "install"
    end
  end
end
