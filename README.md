````
docker build -t ghcr.io/kesokaj/valheim-server:v<VERSION> -t ghcr.io/kesokaj/valheim-server:latest .
docker run -it -d -p 2456:2456 -v "./saves:$HOME/.config/unity3d/IronGate/Valheim/" ghcr.io/kesokaj/valheim-server:latest
docker push ghcr.io/kesokaj/valheim-server --all-tags
````
