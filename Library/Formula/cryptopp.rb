require 'formula'

class Cryptopp < Formula
  homepage 'http://www.cryptopp.com/'
  url 'http://downloads.sourceforge.net/project/cryptopp/cryptopp/5.6.1/cryptopp561.zip'
  sha1 '31dbb456c21f50865218c57b7eaf4c955a222ba1'
  version '5.6.1'

  def patches
    # adds "this->" qualifiers to allow compilation with clang++
    # Upgrades release (SVN rev. 521) to SVN rev. 522, patch will be included in next version
    DATA
  end

  def install
    # patches welcome to re-enable this on configurations that support it
    ENV.append 'CXXFLAGS', '-DCRYPTOPP_DISABLE_ASM'

    system "make", "CXX=#{ENV.cxx}", "CXXFLAGS=#{ENV.cxxflags}"
    lib.install "libcryptopp.a"
    (include+'cryptopp').install Dir["*.h"]
  end
end

__END__
diff --git a/Readme.txt b/Readme.txt
index 1b26794..2f04e9f 100644
--- a/Readme.txt
+++ b/Readme.txt
@@ -1,5 +1,5 @@
 Crypto++: a C++ Class Library of Cryptographic Schemes
-Version 5.6.1 (8/9/2010, SVN r520)
+Version 5.6.2 (in development)
 
 Crypto++ Library is a free C++ class library of cryptographic schemes.
 Currently the library contains the following algorithms:
@@ -41,7 +41,7 @@ Currently the library contains the following algorithms:
       elliptic curve cryptography  ECDSA, ECNR, ECIES, ECDH, ECMQV
 
           insecure or obsolescent  MD2, MD4, MD5, Panama Hash, DES, ARC4, SEAL
-algorithms retained for backwards  3.0, WAKE, WAKE-OFB, DESX (DES-XEX3), RC2,
+algorithms retained for backwards  3.0, WAKE-OFB, DESX (DES-XEX3), RC2,
      compatibility and historical  SAFER, 3-WAY, GOST, SHARK, CAST-128, Square
                             value
 
diff --git a/algebra.cpp b/algebra.cpp
index 78c3947..b8818e6 100644
--- a/algebra.cpp
+++ b/algebra.cpp
@@ -58,7 +58,7 @@ template <class T> const T& AbstractEuclideanDomain<T>::Gcd(const Element &a, co
 	Element g[3]={b, a};
 	unsigned int i0=0, i1=1, i2=2;
 
-	while (!Equal(g[i1], this->Identity()))
+	while (!this->Equal(g[i1], this->Identity()))
 	{
 		g[i2] = Mod(g[i0], g[i1]);
 		unsigned int t = i0; i0 = i1; i1 = i2; i2 = t;
diff --git a/eccrypto.cpp b/eccrypto.cpp
index fd8462f..922104c 100644
--- a/eccrypto.cpp
+++ b/eccrypto.cpp
@@ -435,7 +435,7 @@ template <class EC> void DL_GroupParameters_EC<EC>::Initialize(const OID &oid)
 	StringSource ssG(param.g, true, new HexDecoder);
 	Element G;
 	bool result = GetCurve().DecodePoint(G, ssG, (size_t)ssG.MaxRetrievable());
-	SetSubgroupGenerator(G);
+	this->SetSubgroupGenerator(G);
 	assert(result);
 
 	StringSource ssN(param.n, true, new HexDecoder);
@@ -591,7 +591,7 @@ bool DL_GroupParameters_EC<EC>::ValidateElement(unsigned int level, const Elemen
 	if (level >= 2 && pass)
 	{
 		const Integer &q = GetSubgroupOrder();
-		Element gq = gpc ? gpc->Exponentiate(this->GetGroupPrecomputation(), q) : ExponentiateElement(g, q);
+		Element gq = gpc ? gpc->Exponentiate(this->GetGroupPrecomputation(), q) : this->ExponentiateElement(g, q);
 		pass = pass && IsIdentity(gq);
 	}
 	return pass;
@@ -629,7 +629,7 @@ void DL_PublicKey_EC<EC>::BERDecodePublicKey(BufferedTransformation &bt, bool pa
 	typename EC::Point P;
 	if (!this->GetGroupParameters().GetCurve().DecodePoint(P, bt, size))
 		BERDecodeError();
-	SetPublicElement(P);
+	this->SetPublicElement(P);
 }
 
 template <class EC>
diff --git a/eccrypto.h b/eccrypto.h
index b359e03..3530455 100644
--- a/eccrypto.h
+++ b/eccrypto.h
@@ -43,7 +43,7 @@ public:
 	void Initialize(const EllipticCurve &ec, const Point &G, const Integer &n, const Integer &k = Integer::Zero())
 	{
 		this->m_groupPrecomputation.SetCurve(ec);
-		SetSubgroupGenerator(G);
+		this->SetSubgroupGenerator(G);
 		m_n = n;
 		m_k = k;
 	}
@@ -145,9 +145,9 @@ public:
 	typedef typename EC::Point Element;
 
 	void Initialize(const DL_GroupParameters_EC<EC> &params, const Element &Q)
-		{this->AccessGroupParameters() = params; SetPublicElement(Q);}
+		{this->AccessGroupParameters() = params; this->SetPublicElement(Q);}
 	void Initialize(const EC &ec, const Element &G, const Integer &n, const Element &Q)
-		{this->AccessGroupParameters().Initialize(ec, G, n); SetPublicElement(Q);}
+		{this->AccessGroupParameters().Initialize(ec, G, n); this->SetPublicElement(Q);}
 
 	// X509PublicKey
 	void BERDecodePublicKey(BufferedTransformation &bt, bool parametersPresent, size_t size);
@@ -166,9 +166,9 @@ public:
 	void Initialize(const EC &ec, const Element &G, const Integer &n, const Integer &x)
 		{this->AccessGroupParameters().Initialize(ec, G, n); this->SetPrivateExponent(x);}
 	void Initialize(RandomNumberGenerator &rng, const DL_GroupParameters_EC<EC> &params)
-		{GenerateRandom(rng, params);}
+		{this->GenerateRandom(rng, params);}
 	void Initialize(RandomNumberGenerator &rng, const EC &ec, const Element &G, const Integer &n)
-		{GenerateRandom(rng, DL_GroupParameters_EC<EC>(ec, G, n));}
+		{this->GenerateRandom(rng, DL_GroupParameters_EC<EC>(ec, G, n));}
 
 	// PKCS8PrivateKey
 	void BERDecodePrivateKey(BufferedTransformation &bt, bool parametersPresent, size_t size);
diff --git a/panama.cpp b/panama.cpp
index 09b1708..a1a37d6 100644
--- a/panama.cpp
+++ b/panama.cpp
@@ -422,7 +422,7 @@ void PanamaHash<B>::TruncatedFinal(byte *hash, size_t size)
 {
 	this->ThrowIfInvalidTruncatedSize(size);
 
-	PadLastBlock(this->BLOCKSIZE, 0x01);
+	this->PadLastBlock(this->BLOCKSIZE, 0x01);
 	
 	HashEndianCorrectedBlock(this->m_data);
 
diff --git a/secblock.h b/secblock.h
index 24b9fc0..40cce33 100644
--- a/secblock.h
+++ b/secblock.h
@@ -88,7 +88,7 @@ public:
 
 	pointer allocate(size_type n, const void * = NULL)
 	{
-		CheckSize(n);
+		this->CheckSize(n);
 		if (n == 0)
 			return NULL;
