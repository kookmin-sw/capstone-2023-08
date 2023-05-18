const USER_ID = 'USER_ID';
const USER_NAME = 'USER_NAME';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';
const FIRST_LOGIN = 'FIRST_LOGIN';

const String IP = 'http://35.84.85.252:8000';
const String GPU_IP = 'http://44.229.114.135:8000';

// token
const String GET_ACCESS_TOKEN_URL = '$IP/api/token/refresh';

// account 주요 : 로그인, 회원가입, 로그아웃
const String SIGN_UP_URL = '$IP/account/sign-up';
const String SIGN_IN_URL = '$IP/account/sign-in';
const String LOGOUT_URL = '$IP/account/logout';

// account 그외 체크, 수정
const String SIGN_UP_ID_CHECK_URL = '$IP/account/check-id';
const String SIGN_UP_NAME_CHECK_URL = '$IP/account/check-name';
const String UPDATE_NAME_URL = '$IP/account/edit-name';
const String UPDATE_PW_URL = '$IP/account/change-pw';
const String UPDATE_IMG_URL = '$IP/account/add-imgurl';

// s3 upload
const String GET_PRESIGNED_URL = '$IP/storage/get-presigned-url';

// goods
const String LIST_URL = '$IP/goods/cloth-list';
const String GOODS_BASE_URL = '$IP/goods/dips';
const String GOODS_ADD_URL = '$GOODS_BASE_URL/add';
const String GOODS_DELETE_URL = '$GOODS_BASE_URL/delete';
const String GOODS_SHOW_URL = '$GOODS_BASE_URL/show';

// gpu api
const String HUMAN_INFER_URL = '$GPU_IP/dl/human';
const String RESULT_INFER_URL = '$GPU_IP/dl/infer';
const String FEEDBACK_URL = '$GPU_IP/dl/feedback';