class Blst < Formula
  desc "Multilingual BLS12-381 signature library"
  homepage "https://github.com/supranational/blst"
  url "https://github.com/supranational/blst/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "2d17ed3087bd37d2aff6fd37c83807831fcc62bcbbe71bb65d32d7ded5749faa"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/blst-0.3.14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3cfef213f914c0f2b3a360bb1708cd63aa36cc8a0a157bb68743bb4db1cabbc3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1499fdf4dde947e14a421921cab99c8167dbf08ca7901f85e9f4b2dcb6e05ed4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4d97a995670ec6a9f51ed9287d8232341edac2ab5fe6b6c399739fed05d577b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "23b0aa463e8e84c4a75653357e4cb470796990a84b9885aea9dd7fd037096a2c"
  end

  def install
    system "./build.sh"
    File.write("libblst.pc", <<~PCFILE
      Name: libblst
      Description: Multilingual BLS12-381 signature library
      URL: https://github.com/supranational/blst
      Version: 0.3.14
      Cflags: -I#{include}
      Libs: -L#{lib} -lblst
    PCFILE
    )
    lib.install "libblst.a"
    (lib/"pkgconfig").install "libblst.pc"
    include.install "bindings/blst.h"
    include.install "bindings/blst.hpp"
    include.install "bindings/blst_aux.h"
  end

  def caveats
    <<~EOS
      You may need to set environment variables for this library to work, e.g.:
        export CPATH="#{opt_include}:$CPATH"
        export LDFLAGS="-L#{opt_lib} -lblst $LDFLAGS"
        export LD_LIBRARY_PATH="#{opt_lib}:$LD_LIBRARY_PATH"
      Alternatively you can use pkgconf, e.g.:
        clang $(pkgconf --cflags --libs libblst) -o test test.c
      However, if you are not using pkgconf from Homebrew, this may require you
      to set another environment variable, something like:
        export PKG_CONFIG_PATH=#{HOMEBREW_PREFIX}/lib/pkgconfig:$PKG_CONFIG_PATH
    EOS
  end

  test do
    (testpath/"test.c").write <<~CFILE
      #include <blst.h>
      int main() {
          if (blst_pairing_sizeof() > 0) return 0;
          else return 1;
      }
    CFILE
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lblst", "-o", "test"
    system "./test"
  end
end
