package ers

import (
	"fmt"
	"runtime"
)

func wrap(err error) error {
	buf := make([]byte, 4096)
	return fmt.Errorf("%w\n%s", err, string(buf[:runtime.Stack(buf, false)]))
}
