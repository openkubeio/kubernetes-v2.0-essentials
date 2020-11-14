# Crete dir certs if not exists
mkdir -p certs

# verify args

# export common variables 
CommonName=openkube.io

# export functional variables
export SubjectName

generateCA(){

# Create Root Key
openssl genrsa -des3 -out certs/rootCA.key 4096

# Create and self sign the Root Certificate
openssl req -x509 -new -nodes -key certs/rootCA.key -sha256 -days 1024 -out certs/rootCA.crt -subj "/C=US/ST=CA/O=OpenKube/CN=$CommonName"
}

generateCert(){

echo "Generating cert for ${SubjectName}.${CommonName}"

# Create the certificate key
openssl genrsa -out certs/${SubjectName}.${CommonName}.key 2048

# Create certificate signing request
openssl req -new -sha256 -key certs/${SubjectName}.${CommonName}.key -subj "/C=US/ST=CA/O=OpenKube/CN=*.$CommonName" -out certs/${SubjectName}.${CommonName}.csr

# Create certificate
openssl x509 -req -in certs/${SubjectName}.${CommonName}.csr -CA certs/rootCA.crt -CAkey certs/rootCA.key -CAcreateserial -out certs/${SubjectName}.${CommonName}.crt -days 800 -sha256
}

verifyCSR(){

# Verify the csr's content
openssl req -in certs/${CSRName}.csr -noout -text
}

verifyCert(){

# Verify the certificate's content
openssl x509 -in traefik.${certName}.crt -text -noout
}

help(){
echo ""
echo "./GenerateCerts.sh generateCA"
echo "./GenerateCerts.sh generateCert <subjectName>"
}

case $1 in
   generateCA)
      generateCA
      ;;
   generateCert)
      SubjectName="$2"
      generateCert
      ;;
   verifyCert)
      verifyCert
      ;;
   *)
      help
     ;;
esac 

