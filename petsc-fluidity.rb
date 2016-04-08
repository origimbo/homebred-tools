class PetscFluidity < Formula
  desc ""
  homepage "http://ftp.mcs.anl.gov/pub/petsc/"
  url "http://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.6.3.tar.gz"
  version "3.6.3-fluidity"
  sha256 "2458956c876496f3c8160591324459be7c11f2e1ce09ad98347394c67a46d858"

  depends_on "cmake" => :build
  depends_on :x11
  depends_on "hypre"
  depends_on "gcc"
  depends_on "netcdf" => "with-fortran"
  depends_on "hdf5" => "with-mpi"
  depends_on "valgrind"
  depends_on "scalapack"
  depends_on "mumps"
  depends_on "suite-sparse"
  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran

  keg_only "Don't conflict with default homebrew petsc installation."

  fails_with :llvm
  fails_with :clang
  fails_with :gcc_4_0
  fails_with :gcc do
    build 5666
    cause "need a recent version of gcc."
  end

  def oprefix(f)
    Formula[f].opt_prefix
  end



  def install
    ENV.deparallelize

    ENV["OMPI_FC"] = ENV["FC"]
    ENV["OMPI_F77"] = ENV["FC"]

    ENV["PETSC_DIR"] = Dir.getwd

    ENV["WRAPPER_DIR"] = "#{HOMEBREW_PREFIX}/Library/Taps/origimbo/homebrew-tools/wrappers"

    cp Dir["#{HOMEBREW_PREFIX}/Library/Taps/origimbo/homebrew-tools/wrappers/*"], Dir.getwd

    bin.install "mpicc-5"
    bin.install "mpicxx-5"

    system "./configure", "--with-shared-libraries=0",
                          "--with-pic=fPIC",
                          "--with-cc=#{bin}/mpicc-5",
                          "--with-cxx=#{bin}/mpicxx-5",
                          "--with-fc=#{ENV["MPIFC"]}",
                          "--with-debugging=0",
                          "--useThreads 0",
                          "--with-clanguage=c++",
                          "--with-c-support",
                          "--with-fortran-interfaces=1",
                          "--download-blacs",
                          "--with-hypre-dir=#{oprefix("hypre")}",
                          "--download-ml",
                          "--download-ctetgen",
                          "--download-chaco",
                          "--download-metis",
                          "--download-parmetis",
                          "--with-netcdf=1",
                          "--with-netcdf-dir=#{oprefix("netcdf")}",
                          "--with-hdf5",
                          "--with-hdf5-dir=#{oprefix("hdf5")}",
                          "--with-mumps-dir=#{oprefix("mumps")}/libexec",
                          "--with-suitesparse-dir=#{oprefix("suite-sparse")}",
                          "--with-scalapack-dir=#{oprefix("scalapack")}",
                          "--with-scalar-type=real",
                          "--prefix=#{prefix}"
    system "make", "all"
    system "make", "install"

  end

  test do
    system "true"
  end
end
