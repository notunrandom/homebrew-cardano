class Secp256k1AT032 < Formula
  desc "Optimized C library for EC operations on curve secp256k1"
  homepage "https://github.com/bitcoin-core/secp256k1"
  url "https://github.com/bitcoin-core/secp256k1/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "ef2e1061951b8cf94a7597b4e60fd7810613e327e25305e8d73dfdff67d12190"
  license "MIT"

  bottle do
    root_url "https://github.com/notunrandom/homebrew-cardano/releases/download/secp256k1@0.3.2-0.3.2"
    sha256 cellar: :any,                 arm64_tahoe:  "49565524006003e2306f7a6576f73c6c60413cce06ec2b930de65d82b8417840"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "ed719636c378bf833e39279e91d96f6caa2103ff0695f11c78bdcdc942365a0b"
  end

  keg_only :versioned_formula

  depends_on "autoconf" => [:build]
  depends_on "automake" => [:build]
  depends_on "libtool" => [:build]

  def install
    system "./autogen.sh"
    args = %w[
      --disable-silent-rules
      --enable-module-recovery
      --enable-module-ecdh
      --enable-module-schnorrsig
      --enable-module-extrakeys
    ]
    system "./configure", *args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <secp256k1.h>
      int main() {
        secp256k1_context* ctx = secp256k1_context_create(SECP256K1_CONTEXT_NONE);
        secp256k1_context_destroy(ctx);
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsecp256k1", "-o", "test"
    system "./test"
  end
end
