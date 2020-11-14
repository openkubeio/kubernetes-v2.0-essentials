# Crete dir certs if not exists
mkdir -p certs

# export common variables 
CommonName=openkube.io

# verify args
if [[ $# -lt 1 ]] ; then echo -en  "\n$0 help\n" ; exit 1 ; fi

generateCA(){

# Create Root Key
openssl genrsa -des3 -out certs/rootCA.key 4096

# Create and self sign the Root Certificate
openssl req -x509 -new -nodes -key certs/rootCA.key -sha256 -days 1024 -out certs/rootCA.crt -subj "/C=US/ST=CA/O=OpenKube/CN=$CommonName"
}

generateCert(){

# export functional variables
SubjectName=$2

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
      generateCert
      ;;
   verifyCert)
      verifyCert
      ;;
   *)
      help
     ;;
esac 

