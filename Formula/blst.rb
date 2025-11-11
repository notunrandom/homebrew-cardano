class Blst < Formula
  desc "Multilingual BLS12-381 signature library"
  homepage "https://github.com/supranational/blst"
  url "https://github.com/supranational/blst/archive/refs/tags/v0.3.14.tar.gz"
  sha256 "2d17ed3087bd37d2aff6fd37c83807831fcc62bcbbe71bb65d32d7ded5749faa"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/blst-0.3.14"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:  "ffff8444f1bd4e97f69d2d6703178a109d1216b6299d26ed90294f09eb5c0a53"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "b15b53c066399ffeb39d6604eef9a535bce9741dee577f52b9b91facb290553b"
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
