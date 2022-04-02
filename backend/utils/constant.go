package utils

var (
	// JwtWhiteList - JWT WhiteList
	JwtWhiteList = []string{
		"/content/fetchAllContents",
		"/user/registerUser",
		"/user/loginUser",
		"/user/checkUserDisplayName",
		"/user/checkEmail",
	}
	// AdminWhiteList - Admin WhiteList
	AdminWhiteList = []string{}
)
