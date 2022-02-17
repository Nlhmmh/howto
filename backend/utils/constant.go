package utils

var (
	// JwtWhiteList - JWT WhiteList
	JwtWhiteList = []string{
		"/user/userRegister",
		"/user/userLogin",
		"/user/userEdit",
		"/user/checkUserDisplayName",
		"/user/setDefaultUserAddress",

		"/user/getAllItemsFromCart",
		"/user/insertItemCart",
		"/user/deleteItemCart",
		"/user/changeCountItemCart",

		"/user/getAllUserAddress",
		"/user/userAddressInsert",
		"/user/userAddressEdit",
		"/user/userAddressDelete",

		"/user/getAllUserOrders",
		"/user/addOrder",
		"/user/getOrder",
		"/user/getCartItemsOfUserOrder",

		"/item/getAllItems",
		"/item/getItem",
		"/item/getImage",
		"/item/searchItems",
	}
	// AdminWhiteList - Admin WhiteList
	AdminWhiteList = []string{
		"/item/getAllItems",
		"/item/getItem",
		"/item/itemInsert",
		"/item/itemEdit",
		"/item/itemDelete",

		"/admin/getAllOrders",
	}
)
