package utils

var (
	// JwtWhiteList - JWT WhiteList
	JwtWhiteList = []string{
		"/content/fetchAllContents",
		"/user/registerUser",
		"/user/loginUser",
		"/user/checkUserDisplayName",
		"/user/checkEmail",
		"/user/fetchAllUsers",
	}

	// AdminWhiteList - Admin WhiteList
	AdminWhiteList = []string{}
)
