# Шаг 4 - перевод инфраструктуры в k8s

* [Результат](#результат)

/kube - манифесты

```
sudo app install kubectl 
sudo app install minikube
minikube start
```

Напишем файлы манифесты Kubernetes: fastapi-deployment.yaml fastapi-service.yaml (папка kube) </br>

- Deployment указывает: запускаемый образ, число реплик (подов), открытие портов
- Service указывает: как экспонировать поды из Deployment наружу. Какой порт снаружи будет связан с каким портом в
  контейнере.

kube по умолчанию использует режим обновления RollingUpdate, который обеспечивает беспрерывную доступность приложения во
время деплоя. </br>
RollingUpdate по очереди обновляет поды: сначала создает новый под с обновленным образом, а только после успешного
запуска нового пода — удаляет старый.
В процессе обновления всегда будет работать по крайней мере один старый под, пока новый не будет полностью готов. Это
гарантирует, что приложение не упадет.

```
kubectl apply -f fastapi-deployment.yaml
kubectl apply -f fastapi-service.yaml  
# проверим перешли ли поды в статус running
kubectl get pods
# если не нашелся образ, загрузим самостоятельно
minikube image load fastapi_image:latest
kubectl rollout restart deployment fastapi-deployment
```

```
minikube service fastapi-service --url
http://192.168.49.2:30144
```

# Результат

![stage4](../pics/step4/Архитектура%20пет-проекта%204.png)