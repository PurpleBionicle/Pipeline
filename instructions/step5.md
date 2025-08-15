# Шаг 5 - HashiCorp Vault без интеграций

* [Результат](#результат)

1) создадим конфигурацию (vault.hcl)
2) запустим контейнер
```
docker run -d \
 --name vault \
 --cap-add=IPC_LOCK \
 -p 8200:8200 \
 -v $(pwd)/vault.hcl:/vault/config/vault.hcl \
 -v vault-data:/vault/file \
 -e 'VAULT_LOCAL_CONFIG={"ui":true}' \
 hashicorp/vault server -config=/vault/config/vault.hcl
```

3) Зайдем в контейнер и зарегистрируем оператора системы с указанием количества ключей для «распечатывания» хранилища. 
В результате мы получим администраторский токен и ключа «запечатывания». С использованием данных
ключей «распечатаем» хранилище (становится доступен интерфейс для работы,
секреты остаются быть зашифрованными) и зайдем под аккаунтом
администратора для настройки системы.
```
docker exec -it vault /bin/sh
vault operator init -key-shares=1 -key-threshold=1
vault operator unseal <Unseal-Key>
vault login <Root-Token>
```

4) С использованием переменной окружения укажем контейнеру, по какому
адресу он должен быть доступен. Добавим движок хранения секретов kv2,
который хранит секреты по принципу «ключ-значение», и создадим два секрета. 
```
export VAULT_ADDR=https://localhost:8300
vault secrets enable -path=secret kv-v2
vault kv put secret/myapp api_key="
sqp_82cdc79faec976880131bfca8752b2e0685a75a7"
db_password="supersecretpass"
```

5) Напишем vault-клиента на питоне (vault/vault_client.py).

6) Зарегистрируем способ аутентификации «AppRole» в Vault и создадим политику. 
```
vault auth enable approle
cat >> myapp-policy.hcl
path "secret/data/myapp" {
 capabilities = ["read"]
}
# CTRL+D для выхода из печати в файл
vault policy write myapp-policy myapp-policy.hcl
```
7) Создадим роль и применим созданную политику доступа к секрету
```
vault write auth/approle/role/myapp-role \
 secret_id_ttl=60m \
 token_ttl=30m \
 token_max_ttl=1h \
 policies="myapp-policy"
```

<h3>Встраивание без интеграции не решает проблему "нулевого секрета"</h3>


# Результат

![stage5](../pics/step5/Архитектура%20пет-проекта%205.png)