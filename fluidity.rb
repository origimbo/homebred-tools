
class Fluidity < Formula
  desc ""
  homepage "FluidityProject.github.io"
  url "https://github.com/FluidityProject/fluidity.git", :branch => "ElCapitanFixes"
  sha256 ""
  version "4.elcapitan"

  depends_on "gcc"
  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran
  depends_on :x11
  depends_on "origimbo/tools/petsc-fluidity"
  depends_on "origimbo/tools/zoltan"
  depends_on "modules"
  depends_on "gmsh"
  depends_on "numpy"
  depends_on "scipy"
  depends_on "matplotlib"
  depends_on "gnu-sed"
  depends_on "udunits"
  depends_on "netcdf" => "with-fortran"

  option "enable-2d-adaptivity", "Build and link libmba2 for 2d adaptivity"
  option "enable-debug", "Build debug version"

  keg_only "Lets test this first!"

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
    # ENV.deparallelize  # if your formula fails when building in parallel

    ENV["CC"] = "#{HOMEBREW_PREFIX}/bin/mpicc-5"
    ENV["CXX"] = "#{HOMEBREW_PREFIX}/bin/mpicxx-5"
    ENV["F77"] = "mpif90"
    ENV["FC"] = "mpif90"

    ENV["CPPFLAGS"] = "-I#{oprefix("jrper/fluidity/zoltan")}/include -I#{oprefix("jrper/fluidity/vtk5")}/include/vtk-5.10"
    ENV["LDFLAGS"] = "-L#{oprefix("jrper/fluidity/vtk5")}/lib/vtk-5.10 -lvtkIO -lvtkHybrid -lvtkGraphics -lvtkRendering -lvtkFiltering -lvtkCommon"
    
    ENV["PETSC_DIR"] = "#{HOMEBREW_PREFIX}/opt/petsc-fluidity"

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
  
end
