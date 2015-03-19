class Libressl < Formula
  homepage "http://www.libressl.org/"
  url "http://ftp.openbsd.org/pub/OpenBSD/LibreSSL/libressl-2.1.5.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/LibreSSL/libressl-2.1.5.tar.gz"
  sha256 "a82379913fd7f4e26e045fcf021aa92a1f683954816bf817b3b696de62e9c3bb"
  revision 1

  option "without-libtls", "Build without libtls"

  bottle do
    sha256 "b1f42ad3d599729c6f942893ef59e1860cc848557e6ea1ab7ff4b70ff626d3fe" => :yosemite
    sha256 "422accbd789a18434e01b4df5815de97316d43739e36dafd4cef41559eb85e4d" => :mavericks
    sha256 "3f530e5898c6eb1657a24a7025f3b6df9725e0e4f1ce3f28d2151d1f6d7efe23" => :mountain_lion
  end

  head do
    url "https://github.com/libressl-portable/portable.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  keg_only "LibreSSL is not linked to prevent conflict with the system OpenSSL."

  # CVE-2015-0207 Segmentation fault in DTLSv1_listen moderate
  # CVE-2015-0209 Use After Free following d2i_ECPrivatekey error low
  # CVE-2015-0286 Segmentation fault in ASN1_TYPE_cmp moderate
  # CVE-2015-0287 ASN.1 structure reuse memory corruption moderate
  # CVE-2015-0289 PKCS7 NULL pointer dereferences moderate
  patch :DATA

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssldir=#{etc}/libressl
      --sysconfdir=#{etc}/libressl
      --with-enginesdir=#{lib}/engines
    ]

    args << "--enable-libtls" if build.with? "libtls"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Install the dummy openssl.cnf file to stop runtime warnings.
    mkdir_p "#{etc}/libressl"
    cp "apps/openssl.cnf", "#{etc}/libressl"
  end

  def post_install
    keychains = %w[
      /Library/Keychains/System.keychain
      /System/Library/Keychains/SystemRootCertificates.keychain
    ]

    # Bootstrap CAs from the system keychain.
    (etc/"libressl/cert.pem").atomic_write `security find-certificate -a -p #{keychains.join(" ")}`
  end

  def caveats; <<-EOS.undent
    A CA file has been bootstrapped using certificates from the system
    keychain. To add additional certificates, place .pem files in
      #{etc}/libressl
    EOS
  end

  test do
    (testpath/"testfile.txt").write("This is a test file")
    expected_checksum = "91b7b0b1e27bfbf7bc646946f35fa972c47c2d32"
    system bin/"openssl", "dgst", "-sha1", "-out", "checksum.txt", "testfile.txt"
    open("checksum.txt") do |f|
      checksum = f.read(100).split("=").last.strip
      assert_equal checksum, expected_checksum
    end
  end
end

__END__
diff --git a/crypto/asn1/a_int.c b/crypto/asn1/a_int.c
index 354fbfd..e751b1f 100644
--- a/crypto/asn1/a_int.c
+++ b/crypto/asn1/a_int.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: a_int.c,v 1.24 2014/07/11 08:44:47 jsing Exp $ */
+/* $OpenBSD: a_int.c,v 1.25 2015/02/10 08:33:10 jsing Exp $ */
 /* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
  * All rights reserved.
  *
@@ -268,7 +268,7 @@ c2i_ASN1_INTEGER(ASN1_INTEGER **a, const unsigned char **pp, long len)
 
 err:
 	ASN1err(ASN1_F_C2I_ASN1_INTEGER, i);
-	if ((ret != NULL) && ((a == NULL) || (*a != ret)))
+	if (a == NULL || *a != ret)
 		M_ASN1_INTEGER_free(ret);
 	return (NULL);
 }
@@ -335,7 +335,7 @@ d2i_ASN1_UINTEGER(ASN1_INTEGER **a, const unsigned char **pp, long length)
 
 err:
 	ASN1err(ASN1_F_D2I_ASN1_UINTEGER, i);
-	if ((ret != NULL) && ((a == NULL) || (*a != ret)))
+	if (a == NULL || *a != ret)
 		M_ASN1_INTEGER_free(ret);
 	return (NULL);
 }
diff --git a/crypto/asn1/a_set.c b/crypto/asn1/a_set.c
index 5db829d..4a14d3f 100644
--- a/crypto/asn1/a_set.c
+++ b/crypto/asn1/a_set.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: a_set.c,v 1.15 2014/07/10 13:58:22 jsing Exp $ */
+/* $OpenBSD: a_set.c,v 1.16 2014/07/11 08:44:47 jsing Exp $ */
 /* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
  * All rights reserved.
  *
@@ -225,7 +225,7 @@ d2i_ASN1_SET(STACK_OF(OPENSSL_BLOCK) **a, const unsigned char **pp, long length,
 	return ret;
 
 err:
-	if (ret != NULL && (a == NULL || *a != ret)) {
+	if (a == NULL || *a != ret) {
 		if (free_func != NULL)
 			sk_OPENSSL_BLOCK_pop_free(ret, free_func);
 		else
diff --git a/crypto/asn1/a_type.c b/crypto/asn1/a_type.c
index e9c8bec..109c235 100644
--- a/crypto/asn1/a_type.c
+++ b/crypto/asn1/a_type.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: a_type.c,v 1.14 2014/07/11 08:44:47 jsing Exp $ */
+/* $OpenBSD: a_type.c,v 1.15 2015/02/10 08:33:10 jsing Exp $ */
 /* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
  * All rights reserved.
  *
@@ -119,7 +119,9 @@ ASN1_TYPE_cmp(ASN1_TYPE *a, ASN1_TYPE *b)
 	case V_ASN1_OBJECT:
 		result = OBJ_cmp(a->value.object, b->value.object);
 		break;
-
+	case V_ASN1_BOOLEAN:
+		result = a->value.boolean - b->value.boolean;
+		break;
 	case V_ASN1_NULL:
 		result = 0;	/* They do not have content. */
 		break;
diff --git a/crypto/asn1/d2i_pr.c b/crypto/asn1/d2i_pr.c
index 46f35ca..687947b 100644
--- a/crypto/asn1/d2i_pr.c
+++ b/crypto/asn1/d2i_pr.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: d2i_pr.c,v 1.12 2014/07/11 08:44:47 jsing Exp $ */
+/* $OpenBSD: d2i_pr.c,v 1.13 2015/02/11 03:19:37 doug Exp $ */
 /* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
  * All rights reserved.
  *
@@ -118,7 +118,7 @@ d2i_PrivateKey(int type, EVP_PKEY **a, const unsigned char **pp, long length)
 	return (ret);
 
 err:
-	if ((ret != NULL) && ((a == NULL) || (*a != ret)))
+	if (a == NULL || *a != ret)
 		EVP_PKEY_free(ret);
 	return (NULL);
 }
diff --git a/crypto/asn1/d2i_pu.c b/crypto/asn1/d2i_pu.c
index 9d76910..b1f69bf 100644
--- a/crypto/asn1/d2i_pu.c
+++ b/crypto/asn1/d2i_pu.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: d2i_pu.c,v 1.11 2014/07/10 22:45:56 jsing Exp $ */
+/* $OpenBSD: d2i_pu.c,v 1.12 2014/07/11 08:44:47 jsing Exp $ */
 /* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
  * All rights reserved.
  *
@@ -130,7 +130,7 @@ d2i_PublicKey(int type, EVP_PKEY **a, const unsigned char **pp, long length)
 	return (ret);
 
 err:
-	if ((ret != NULL) && ((a == NULL) || (*a != ret)))
+	if (a == NULL || *a != ret)
 		EVP_PKEY_free(ret);
 	return (NULL);
 }
diff --git a/crypto/asn1/n_pkey.c b/crypto/asn1/n_pkey.c
index fe93cf5..f45f86a 100644
--- a/crypto/asn1/n_pkey.c
+++ b/crypto/asn1/n_pkey.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: n_pkey.c,v 1.24 2015/02/11 03:39:51 jsing Exp $ */
+/* $OpenBSD: n_pkey.c,v 1.25 2015/02/11 04:00:39 jsing Exp $ */
 /* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
  * All rights reserved.
  *
@@ -340,11 +340,11 @@ d2i_RSA_NET(RSA **a, const unsigned char **pp, long length,
 		return NULL;
 	}
 
-	if ((enckey->os->length != 11) || (strncmp("private-key",
-	(char *)enckey->os->data, 11) != 0)) {
+	/* XXX 11 == strlen("private-key") */
+	if (enckey->os->length != 11 ||
+	    memcmp("private-key", enckey->os->data, 11) != 0) {
 		ASN1err(ASN1_F_D2I_RSA_NET, ASN1_R_PRIVATE_KEY_HEADER_MISSING);
-		NETSCAPE_ENCRYPTED_PKEY_free(enckey);
-		return NULL;
+		goto err;
 	}
 	if (OBJ_obj2nid(enckey->enckey->algor->algorithm) != NID_rc4) {
 		ASN1err(ASN1_F_D2I_RSA_NET,
diff --git a/crypto/asn1/tasn_dec.c b/crypto/asn1/tasn_dec.c
index 38b24e0..06c39a1 100644
--- a/crypto/asn1/tasn_dec.c
+++ b/crypto/asn1/tasn_dec.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: tasn_dec.c,v 1.24 2014/06/12 15:49:27 deraadt Exp $ */
+/* $OpenBSD: tasn_dec.c,v 1.25 2015/02/14 15:23:57 miod Exp $ */
 /* Written by Dr Stephen N Henson (steve@openssl.org) for the OpenSSL
  * project 2000.
  */
@@ -238,8 +238,16 @@ ASN1_item_ex_d2i(ASN1_VALUE **pval, const unsigned char **in, long len,
 		if (asn1_cb && !asn1_cb(ASN1_OP_D2I_PRE, pval, it, NULL))
 			goto auxerr;
 
-		/* Allocate structure */
-		if (!*pval && !ASN1_item_ex_new(pval, it)) {
+		if (*pval) {
+			/* Free up and zero CHOICE value if initialised */
+			i = asn1_get_choice_selector(pval, it);
+			if ((i >= 0) && (i < it->tcount)) {
+				tt = it->templates + i;
+				pchptr = asn1_get_field_ptr(pval, tt);
+				ASN1_template_free(pchptr, tt);
+				asn1_set_choice_selector(pval, -1, it);
+			}
+		} else if (!ASN1_item_ex_new(pval, it)) {
 			ASN1err(ASN1_F_ASN1_ITEM_EX_D2I,
 			    ERR_R_NESTED_ASN1_ERROR);
 			goto err;
@@ -325,6 +333,19 @@ ASN1_item_ex_d2i(ASN1_VALUE **pval, const unsigned char **in, long len,
 		if (asn1_cb && !asn1_cb(ASN1_OP_D2I_PRE, pval, it, NULL))
 			goto auxerr;
 
+		/* Free up and zero any ADB found */
+		for (i = 0, tt = it->templates; i < it->tcount; i++, tt++) {
+			if (tt->flags & ASN1_TFLG_ADB_MASK) {
+				const ASN1_TEMPLATE *seqtt;
+				ASN1_VALUE **pseqval;
+				seqtt = asn1_do_adb(pval, tt, 1);
+				if (!seqtt)
+					goto err;
+				pseqval = asn1_get_field_ptr(pval, seqtt);
+				ASN1_template_free(pseqval, seqtt);
+			}
+		}
+
 		/* Get each field entry */
 		for (i = 0, tt = it->templates; i < it->tcount; i++, tt++) {
 			const ASN1_TEMPLATE *seqtt;
diff --git a/crypto/asn1/x_x509.c b/crypto/asn1/x_x509.c
index 996acad..e0533a4 100644
--- a/crypto/asn1/x_x509.c
+++ b/crypto/asn1/x_x509.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: x_x509.c,v 1.22 2015/02/11 03:39:51 jsing Exp $ */
+/* $OpenBSD: x_x509.c,v 1.23 2015/02/11 04:00:39 jsing Exp $ */
 /* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
  * All rights reserved.
  *
@@ -313,16 +313,20 @@ d2i_X509_AUX(X509 **a, const unsigned char **pp, long length)
 
 	/* Save start position */
 	q = *pp;
-	ret = d2i_X509(a, pp, length);
+	ret = d2i_X509(NULL, pp, length);
 	/* If certificate unreadable then forget it */
 	if (!ret)
 		return NULL;
 	/* update length */
 	length -= *pp - q;
-	if (!length)
-		return ret;
-	if (!d2i_X509_CERT_AUX(&ret->aux, pp, length))
-		goto err;
+	if (length > 0) {
+		if (!d2i_X509_CERT_AUX(&ret->aux, pp, length))
+			goto err;
+	}
+	if (a != NULL) {
+		X509_free(*a);
+		*a = ret;
+	}
 	return ret;
 
 err:
diff --git a/crypto/ec/ec_asn1.c b/crypto/ec/ec_asn1.c
index e565e15..d167915 100644
--- a/crypto/ec/ec_asn1.c
+++ b/crypto/ec/ec_asn1.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: ec_asn1.c,v 1.11 2015/02/10 04:01:26 jsing Exp $ */
+/* $OpenBSD: ec_asn1.c,v 1.12 2015/02/10 05:43:09 jsing Exp $ */
 /*
  * Written by Nils Larsch for the OpenSSL project.
  */
@@ -999,19 +999,19 @@ d2i_ECPKParameters(EC_GROUP ** a, const unsigned char **in, long len)
 
 	if ((params = d2i_ECPKPARAMETERS(NULL, in, len)) == NULL) {
 		ECerr(EC_F_D2I_ECPKPARAMETERS, EC_R_D2I_ECPKPARAMETERS_FAILURE);
-		ECPKPARAMETERS_free(params);
-		return NULL;
+		goto err;
 	}
 	if ((group = ec_asn1_pkparameters2group(params)) == NULL) {
 		ECerr(EC_F_D2I_ECPKPARAMETERS, EC_R_PKPARAMETERS2GROUP_FAILURE);
-		ECPKPARAMETERS_free(params);
-		return NULL;
+		goto err;
 	}
-	if (a && *a)
+
+	if (a != NULL) {
 		EC_GROUP_clear_free(*a);
-	if (a)
 		*a = group;
+	}
 
+err:
 	ECPKPARAMETERS_free(params);
 	return (group);
 }
@@ -1039,7 +1039,6 @@ i2d_ECPKParameters(const EC_GROUP * a, unsigned char **out)
 EC_KEY *
 d2i_ECPrivateKey(EC_KEY ** a, const unsigned char **in, long len)
 {
-	int ok = 0;
 	EC_KEY *ret = NULL;
 	EC_PRIVATEKEY *priv_key = NULL;
 
@@ -1054,12 +1053,9 @@ d2i_ECPrivateKey(EC_KEY ** a, const unsigned char **in, long len)
 	}
 	if (a == NULL || *a == NULL) {
 		if ((ret = EC_KEY_new()) == NULL) {
-			ECerr(EC_F_D2I_ECPRIVATEKEY,
-			    ERR_R_MALLOC_FAILURE);
+			ECerr(EC_F_D2I_ECPRIVATEKEY, ERR_R_MALLOC_FAILURE);
 			goto err;
 		}
-		if (a)
-			*a = ret;
 	} else
 		ret = *a;
 
@@ -1109,17 +1105,19 @@ d2i_ECPrivateKey(EC_KEY ** a, const unsigned char **in, long len)
 			goto err;
 		}
 	}
-	ok = 1;
+
+	EC_PRIVATEKEY_free(priv_key);
+	if (a != NULL)
+		*a = ret;
+	return (ret);
+
 err:
-	if (!ok) {
-		if (ret)
-			EC_KEY_free(ret);
-		ret = NULL;
-	}
+	if (a == NULL || *a != ret)
+		EC_KEY_free(ret);
 	if (priv_key)
 		EC_PRIVATEKEY_free(priv_key);
 
-	return (ret);
+	return (NULL);
 }
 
 int 
@@ -1232,8 +1230,6 @@ d2i_ECParameters(EC_KEY ** a, const unsigned char **in, long len)
 			ECerr(EC_F_D2I_ECPARAMETERS, ERR_R_MALLOC_FAILURE);
 			return NULL;
 		}
-		if (a)
-			*a = ret;
 	} else
 		ret = *a;
 
@@ -1241,6 +1237,9 @@ d2i_ECParameters(EC_KEY ** a, const unsigned char **in, long len)
 		ECerr(EC_F_D2I_ECPARAMETERS, ERR_R_EC_LIB);
 		return NULL;
 	}
+
+	if (a != NULL)
+		*a = ret;
 	return ret;
 }
 
diff --git a/crypto/pkcs7/pk7_doit.c b/crypto/pkcs7/pk7_doit.c
index 0b76d72..7828037 100644
--- a/crypto/pkcs7/pk7_doit.c
+++ b/crypto/pkcs7/pk7_doit.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: pk7_doit.c,v 1.30 2014/10/22 13:02:04 jsing Exp $ */
+/* $OpenBSD: pk7_doit.c,v 1.31 2015/02/07 13:19:15 doug Exp $ */
 /* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
  * All rights reserved.
  *
@@ -261,6 +261,28 @@ PKCS7_dataInit(PKCS7 *p7, BIO *bio)
 	PKCS7_RECIP_INFO *ri = NULL;
 	ASN1_OCTET_STRING *os = NULL;
 
+	if (p7 == NULL) {
+		PKCS7err(PKCS7_F_PKCS7_DATAINIT, PKCS7_R_INVALID_NULL_POINTER);
+		return NULL;
+	}
+
+	/*
+	 * The content field in the PKCS7 ContentInfo is optional,
+	 * but that really only applies to inner content (precisely,
+	 * detached signatures).
+	 *
+	 * When reading content, missing outer content is therefore
+	 * treated as an error.
+	 *
+	 * When creating content, PKCS7_content_new() must be called
+	 * before calling this method, so a NULL p7->d is always
+	 * an error.
+	 */
+	if (p7->d.ptr == NULL) {
+		PKCS7err(PKCS7_F_PKCS7_DATAINIT, PKCS7_R_NO_CONTENT);
+		return NULL;
+	}
+
 	i = OBJ_obj2nid(p7->type);
 	p7->state = PKCS7_S_HEADER;
 
@@ -417,6 +439,17 @@ PKCS7_dataDecode(PKCS7 *p7, EVP_PKEY *pkey, BIO *in_bio, X509 *pcert)
 	unsigned char *ek = NULL, *tkey = NULL;
 	int eklen = 0, tkeylen = 0;
 
+	if (p7 == NULL) {
+		PKCS7err(PKCS7_F_PKCS7_DATADECODE,
+		    PKCS7_R_INVALID_NULL_POINTER);
+		return NULL;
+	}
+
+	if (p7->d.ptr == NULL) {
+		PKCS7err(PKCS7_F_PKCS7_DATADECODE, PKCS7_R_NO_CONTENT);
+		return NULL;
+	}
+
 	i = OBJ_obj2nid(p7->type);
 	p7->state = PKCS7_S_HEADER;
 
@@ -691,6 +724,17 @@ PKCS7_dataFinal(PKCS7 *p7, BIO *bio)
 	STACK_OF(PKCS7_SIGNER_INFO) *si_sk = NULL;
 	ASN1_OCTET_STRING *os = NULL;
 
+	if (p7 == NULL) {
+		PKCS7err(PKCS7_F_PKCS7_DATAFINAL,
+		    PKCS7_R_INVALID_NULL_POINTER);
+		return 0;
+	}
+
+	if (p7->d.ptr == NULL) {
+		PKCS7err(PKCS7_F_PKCS7_DATAFINAL, PKCS7_R_NO_CONTENT);
+		return 0;
+	}
+
 	EVP_MD_CTX_init(&ctx_tmp);
 	i = OBJ_obj2nid(p7->type);
 	p7->state = PKCS7_S_HEADER;
@@ -736,6 +780,7 @@ PKCS7_dataFinal(PKCS7 *p7, BIO *bio)
 		/* If detached data then the content is excluded */
 		if (PKCS7_type_is_data(p7->d.sign->contents) && p7->detached) {
 			M_ASN1_OCTET_STRING_free(os);
+			os = NULL;
 			p7->d.sign->contents->d.data = NULL;
 		}
 		break;
@@ -750,6 +795,7 @@ PKCS7_dataFinal(PKCS7 *p7, BIO *bio)
 		if (PKCS7_type_is_data(p7->d.digest->contents) &&
 		    p7->detached) {
 			M_ASN1_OCTET_STRING_free(os);
+			os = NULL;
 			p7->d.digest->contents->d.data = NULL;
 		}
 		break;
@@ -815,22 +861,32 @@ PKCS7_dataFinal(PKCS7 *p7, BIO *bio)
 		M_ASN1_OCTET_STRING_set(p7->d.digest->digest, md_data, md_len);
 	}
 
-	if (!PKCS7_is_detached(p7) && !(os->flags & ASN1_STRING_FLAG_NDEF)) {
-		char *cont;
-		long contlen;
-		btmp = BIO_find_type(bio, BIO_TYPE_MEM);
-		if (btmp == NULL) {
-			PKCS7err(PKCS7_F_PKCS7_DATAFINAL,
-			    PKCS7_R_UNABLE_TO_FIND_MEM_BIO);
+	if (!PKCS7_is_detached(p7)) {
+		/*
+		 * NOTE: only reach os == NULL here because detached
+		 * digested data support is broken?
+		 */
+		if (os == NULL)
 			goto err;
+		if (!(os->flags & ASN1_STRING_FLAG_NDEF)) {
+			char *cont;
+			long contlen;
+
+			btmp = BIO_find_type(bio, BIO_TYPE_MEM);
+			if (btmp == NULL) {
+				PKCS7err(PKCS7_F_PKCS7_DATAFINAL,
+				    PKCS7_R_UNABLE_TO_FIND_MEM_BIO);
+				goto err;
+			}
+			contlen = BIO_get_mem_data(btmp, &cont);
+			/*
+			 * Mark the BIO read only then we can use its copy
+			 * of the data instead of making an extra copy.
+			 */
+			BIO_set_flags(btmp, BIO_FLAGS_MEM_RDONLY);
+			BIO_set_mem_eof_return(btmp, 0);
+			ASN1_STRING_set0(os, (unsigned char *)cont, contlen);
 		}
-		contlen = BIO_get_mem_data(btmp, &cont);
-		/* Mark the BIO read only then we can use its copy of the data
-		 * instead of making an extra copy.
-		 */
-		BIO_set_flags(btmp, BIO_FLAGS_MEM_RDONLY);
-		BIO_set_mem_eof_return(btmp, 0);
-		ASN1_STRING_set0(os, (unsigned char *)cont, contlen);
 	}
 	ret = 1;
 err:
@@ -905,6 +961,17 @@ PKCS7_dataVerify(X509_STORE *cert_store, X509_STORE_CTX *ctx, BIO *bio,
 	STACK_OF(X509) *cert;
 	X509 *x509;
 
+	if (p7 == NULL) {
+		PKCS7err(PKCS7_F_PKCS7_DATAVERIFY,
+		    PKCS7_R_INVALID_NULL_POINTER);
+		return 0;
+	}
+
+	if (p7->d.ptr == NULL) {
+		PKCS7err(PKCS7_F_PKCS7_DATAVERIFY, PKCS7_R_NO_CONTENT);
+		return 0;
+	}
+
 	if (PKCS7_type_is_signed(p7)) {
 		cert = p7->d.sign->cert;
 	} else if (PKCS7_type_is_signedAndEnveloped(p7)) {
@@ -941,6 +1008,7 @@ PKCS7_dataVerify(X509_STORE *cert_store, X509_STORE_CTX *ctx, BIO *bio,
 
 	return PKCS7_signatureVerify(bio, p7, si, x509);
 err:
+	
 	return ret;
 }
 
diff --git a/crypto/pkcs7/pk7_lib.c b/crypto/pkcs7/pk7_lib.c
index 9fe0a2a..b614e3b 100644
--- a/crypto/pkcs7/pk7_lib.c
+++ b/crypto/pkcs7/pk7_lib.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: pk7_lib.c,v 1.13 2014/07/11 08:44:49 jsing Exp $ */
+/* $OpenBSD: pk7_lib.c,v 1.14 2014/07/12 16:03:37 miod Exp $ */
 /* Copyright (C) 1995-1998 Eric Young (eay@cryptsoft.com)
  * All rights reserved.
  *
@@ -460,6 +460,8 @@ PKCS7_set_digest(PKCS7 *p7, const EVP_MD *md)
 STACK_OF(PKCS7_SIGNER_INFO) *
 PKCS7_get_signer_info(PKCS7 *p7)
 {
+	if (p7 == NULL || p7->d.ptr == NULL)
+		return (NULL);
 	if (PKCS7_type_is_signed(p7)) {
 		return (p7->d.sign->signer_info);
 	} else if (PKCS7_type_is_signedAndEnveloped(p7)) {
diff --git a/ssl/d1_lib.c b/ssl/d1_lib.c
index e500a19..8758c37 100644
--- a/ssl/d1_lib.c
+++ b/ssl/d1_lib.c
@@ -1,4 +1,4 @@
-/* $OpenBSD: d1_lib.c,v 1.26 2014/12/14 15:30:50 jsing Exp $ */
+/* $OpenBSD: d1_lib.c,v 1.27 2015/02/09 10:53:28 jsing Exp $ */
 /*
  * DTLS implementation written by Nagendra Modadugu
  * (nagendra@cs.stanford.edu) for the OpenSSL project 2005.
@@ -443,6 +443,9 @@ dtls1_listen(SSL *s, struct sockaddr *client)
 {
 	int ret;
 
+	/* Ensure there is no state left over from a previous invocation */
+	SSL_clear(s);
+
 	SSL_set_options(s, SSL_OP_COOKIE_EXCHANGE);
 	s->d1->listen = 1;
 
