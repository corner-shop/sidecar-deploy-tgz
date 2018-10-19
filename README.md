## sidecar-deploy-tgz

A docker sidecar container that can be used to deploy a set of files onto a docker volume or a host filesystem.
This can be used to 'simplify' the deployment of configuration files for docker
containers which are not fully factor12.

Example:

    mkdir app
    cd app
    cat <<EOF>app.conf
    http_port=9999
    other_stuff=hello
    [inifile style]
    blah blah
    EOF
    tar czf - . | base64 -w0
    H4sIAOybyVsAA+3RwQrCIBzHcc8+hU+wMnXSoSeJiBUbG0gbmzvU0+ciiA7VaUT0/RwU/wr+4JctxOyWiXcu7Sa3ejWdtXf6Nr8T2ph8ZbTzNk9z760Wys0fTYhxiEWvlCguY3j37tP9j8oWRddlx/ZUzffHVHBu7ev+vX3uX2vjU//L+SI9/Hn/dYzdvmv7uFknso112e+HOFbVpi5DaOW2OTVVE0o1xHMod/IQilpNi5Tfzg4AAAAAAAAAAAAAAAD8uysMTwe1ACgAAA==

Then deploy this container as:

    docker volume create conf

    docker run -d --rm -v conf:/conf -e WORKDIR=/conf -e TGZ='H4sIAOybyVsAA+3RwQrCIBzHcc8+hU+wMnXSoSeJiBUbG0gbmzvU0+ciiA7VaUT0/RwU/wr+4JctxOyWiXcu7Sa3ejWdtXf6Nr8T2ph8ZbTzNk9z760Wys0fTYhxiEWvlCguY3j37tP9j8oWRddlx/ZUzffHVHBu7ev+vX3uX2vjU//L+SI9/Hn/dYzdvmv7uFknso112e+HOFbVpi5DaOW2OTVVE0o1xHMod/IQilpNi5Tfzg4AAAAAAAAAAAAAAAD8uysMTwe1ACgAAA==' registry.gitlab.com/thecornershop/sidecar-deploy-tgz:next-release
    3b6dcbc2be5ee098ce288f20d6207551b75cd45d1d35f74c133980312baa0448

    docker logs 3b6dcbc2be5ee098ce288f20d6207551b75cd45d1d35f74c133980312baa0448
    /conf
    /conf/app.conf

Let's pretend we deploy an app that consumes /app/conf/app.conf for its config:

    docker run -d --rm -v conf:/app/conf alpine sleep 999999999
    faa815ca3d3fea849217e4efba40e92b47b8e084eac8830aadef5f9f911f23a7

    docker exec -it faa815ca3d3fea849217e4efba40e92b47b8e084eac8830aadef5f9f911f23a7 cat /app/conf/app.conf

    http_port=9999
    other_stuff=hello
    [inifile style]
    blah blah
