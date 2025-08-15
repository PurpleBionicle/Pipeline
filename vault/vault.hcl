storage "file" {
  path = "/vault/file"
}
listener "tcp" {
  address    = "0.0.0.0:8200"
  tls_enable = 1
}
disable_mlock = true
ui            = true