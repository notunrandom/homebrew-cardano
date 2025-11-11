class LibsodiumCardano < Formula
  desc "Cardano fork of libsodium crypto library"
  homepage "https://github.com/intersectmbo/libsodium"
  url "https://github.com/intersectmbo/libsodium/archive/dbb48cce5429cb6585c9034f002568964f1ce567.tar.gz"
  version "1.0.0"
  sha256 "e4f29ae3c16037e484bb69e3fa22a5565c42adf497f8f88e61ff8d9486ab863e"
  license "ISC"

  depends_on "autoconf" => :build
  depends_on "autogen" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  conflicts_with "libsodium"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    system "make", "install"
  end

  def caveats
    <<~EOS
      You may need to set environment variables for this library to work, e.g.:
        export CPATH="#{opt_include}:$CPATH"
        export LDFLAGS="-L#{opt_lib} -lsodium $LDFLAGS"
        export LD_LIBRARY_PATH="#{opt_lib}:$LD_LIBRARY_PATH"
      Alternatively you can use pkgconf, e.g.:
        clang $(pkgconf --cflags --libs libsodium) -o test test.c
      However, if you are not using pkgconf from Homebrew, this may require you
      to set another environment variable:
        export PKG_CONFIG_PATH=#{HOMEBREW_PREFIX}/lib/pkgconfig:$PKG_CONFIG_PATH
    EOS
  end

  test do
    (testpath/"test.c").write <<~CFILE
      #include <sodium.h>
      int main(void) {
          if (sodium_init() == -1) {
              return 1;
          }
          return 0;
      }
    CFILE
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsodium", "-o", "test"
    system "./test"
  end
end
