package server

import (
	"io/ioutil"

	"gopkg.in/yaml.v3"
)

var (
	config Config
)

type Config struct {
	DeleteMedia     bool     `yaml:"deleteMedia"`
	DeleteLogs      bool     `yaml:"deleteLogs"`
	PortNo          string   `yaml:"portNo"`
	AllowedOrigins  []string `yaml:"allowedOrigins"`
	DBInfo          string   `yaml:"dbInfo"`
	JWTExpiredHours int      `yaml:"jwtExpiredHours"`
}

func init() {

	configFile, err := ioutil.ReadFile("config.yaml")
	if err != nil {
		panic(err)
	}

	if err := yaml.Unmarshal(configFile, &config); err != nil {
		panic(err)
	}

}

func GetConfig() Config {
	return config
}
