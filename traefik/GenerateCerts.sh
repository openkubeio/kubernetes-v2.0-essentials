# Crete dir certs if not exists
mkdir -p certs

# export common variables 
CommonName=openkube.io

# Create Root Key
openssl genrsa -des3 -out certs/rootCA.key 4096

# Create and self sign the Root Certificate
openssl req -x509 -new -nodes -key certs/rootCA.key -sha256 -days 1024 -out certs/rootCA.crt -subj "/C=US/ST=CA/O=OpenKube/CN=$CommonName"

# Create the certificate key
openssl genrsa -out certs/traefik.$CommonName.key 2048
 
# Create certificate signing request
openssl req -new -sha256 -key certs/traefik.$CommonName.key -subj "/C=US/ST=CA/O=OpenKube/CN=*.$CommonName" -out certs/traefik.$CommonName.csr

# Verify the csr's content
# openssl req -in certs/traefik.$instance.$CommonName.csr -noout -text

# Create certificate
openssl x509 -req -in certs/traefik.$CommonName.csr -CA certs/rootCA.crt -CAkey certs/rootCA.key -CAcreateserial -out certs/traefik.$CommonName.crt -days 800 -sha256

# Verify the certificate's content
# openssl x509 -in traefik.$CommonName.crt -text -noout
