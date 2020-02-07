GITCOMMIT=`git describe --always`
VERSION=$$(git describe 2>/dev/null || echo "0.0.0-${GITCOMMIT}")
GITDATE=`TZ=UTC git show -s --date=iso-strict-local --format=%cd HEAD`
BUILDDATE=`date -u +"%Y-%m-%dT%H:%M:%S%:z"`
PACKAGE=eth2-exporter
LDFLAGS="-X ${PACKAGE}/version.Version=${VERSION} -X ${PACKAGE}/version.BuildDate=${BUILDDATE} -X ${PACKAGE}/version.GitCommit=${GITCOMMIT} -X ${PACKAGE}/version.GitDate=${GITDATE}"

all: explorer frontend

lint:
	golint ./...

explorer:
	go build --ldflags=${LDFLAGS} -o bin/indexer cmd/indexer/main.go

frontend:
	rm -rf bin/templates
	rm -rf bin/static
	mkdir -p bin/templates/
	mkdir -p bin/static/
	cp -r templates/ bin/
	cp -r static/ bin/
	go build --ldflags=${LDFLAGS} -o bin/frontend cmd/frontend/main.go