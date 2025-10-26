package util

import (
	"os"
	"strings"

	"github.com/charmbracelet/log"
)

func EnvLogLevel() {
	denvLog := strings.ToUpper(os.Getenv("DENV_LOG"))
	switch denvLog {
	case "DEBUG":
		log.SetLevel(log.DebugLevel)
	case "WARN":
		log.SetLevel(log.WarnLevel)
	case "ERROR":
		log.SetLevel(log.ErrorLevel)
	case "FATAL":
		log.SetLevel(log.FatalLevel)
	default:
		log.SetLevel(log.InfoLevel)
	}
}
