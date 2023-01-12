package main

import (
	"flag"
	"fmt"
	"net"
	"net/http"
	"os"
	"strconv"
)

var port = flag.Int("port", 80, "The port to listen on for HTTP requests.")

func main() {
	flag.Parse()

	service := newService()

	http.ListenAndServe(":"+strconv.Itoa(*port), service)
}

type service struct {
	mux *http.ServeMux
}

func (s *service) ServeHTTP(w http.ResponseWriter, r *http.Request) {
	s.mux.ServeHTTP(w, r)
}

func newService() http.Handler {
	s := &service{
		mux: http.NewServeMux(),
	}

	s.mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
		name := getURLNameQuery(r)
		hostname := getHostname()
		ipAddress := getIPAddress()

		w.Header().Set("Content-Type", "application/json")
		fmt.Fprintf(w, `{"name": "%s", "hostname": "%s", "ipAddress": "%s"}`, name, hostname, ipAddress)
	})

	return s
}

func getURLNameQuery(r *http.Request) string {
	name := r.URL.Query().Get("name")
	if name == "" {
		name = "World"
	}
	return name
}

func getHostname() string {
	hostname, err := os.Hostname()
	if err != nil {
		panic(err)
	}
	return hostname
}

func getIPAddress() string {
	addrs, err := net.InterfaceAddrs()
	if err != nil {
		panic(err)
	}
	for _, address := range addrs {
		if ipnet, ok := address.(*net.IPNet); ok && !ipnet.IP.IsLoopback() {
			if ipnet.IP.To4() != nil {
				return ipnet.IP.String()
			}
		}
	}
	return ""
}
