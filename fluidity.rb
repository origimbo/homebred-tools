
class Fluidity < Formula
  desc ""
  homepage "http://FluidityProject.github.io"
  url "https://github.com/FluidityProject/fluidity.git", :branch => "system_judy_spatialindex"
  sha256 ""
  version "4.13"

  depends_on :mpi => [:cc, :cxx, :f77, :f90]
  depends_on :fortran
  depends_on :x11
  depends_on "origimbo/tools/petsc-fluidity"
  depends_on "origimbo/tools/zoltan"
  depends_on "python"
  depends_on "numpy"
  depends_on "udunits"
  depends_on "gnu-sed"
  depends_on "vtk5"
  depends_on "judy"
  depends_on "spatialindex"
  depends_on "origimbo/tools/libspud"

  option "enable-2d-adaptivity", "Build and link libmba2 for 2d adaptivity"
  option "enable-debug", "Build debug version"

  keg_only "Lets test this first!"

  fails_with :llvm 
  fails_with :gcc_4_0

  def oprefix(f)
    Formula[f].opt_prefix
  end

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    ENV["CPPFLAGS"] = "-I#{oprefix("origimbo/tools/zoltan")}/include -I#{oprefix("vtk5")}/include/vtk-5.10"
    ENV["LDFLAGS"] = "-L#{oprefix("vtk5")}/lib/vtk-5.10 -lvtkIO -lvtkHybrid -lvtkGraphics -lvtkRendering -lvtkFiltering -lvtkCommon"
    
    ENV["PETSC_DIR"] = "#{HOMEBREW_PREFIX}/opt/petsc-fluidity"

    system "./configure", "--prefix=#{prefix}",
                          "--with-libspud-root=#{HOMEBREW_PREFIX}",
                          "--with-spatialindex-root=#{HOMEBREW_PREFIX}",
                          "--with-judy=#{oprefix("judy")}/lib/libjudy.a"
    system "make"
    system "make", "install"
  end
  
end
