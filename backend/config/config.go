package config

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
	PortNo          int64    `yaml:"portNo"`
	AllowedOrigins  []string `yaml:"allowedOrigins"`
	DBInfo          string   `yaml:"dbInfo"`
	JWTExpiredHours int64    `yaml:"jwtExpiredHours"`
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
