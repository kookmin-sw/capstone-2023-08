import requests
from urllib.request import urlretrieve, Request, urlopen
import boto3
from bs4 import BeautifulSoup

MUSINSA_URL = "https://www.musinsa.com/ranking/best?"
s3 = boto3.client('s3')

def crawl_image() :
    top_param = {"period" : "now",
                "age" : "ALL",
                "mainCategory" : "001",
                "page" : 1,
                "viewType" : "small"}
    response = requests.get(MUSINSA_URL, params=top_param)
    if response.status_code == 200:
        html = response.text
        soup = BeautifulSoup(html, 'html.parser')
    else:
        raise Exception(f"Musinsa Request Failed. Status Code is {response.status_code}")

    # make list of detail page's url
    goods_rank_list = soup.select_one("form#goodsRankForm").select_one("ul#goodsRankList").select("li.li_box")
    detail_page_url_list = list()
    for element in goods_rank_list:
        url = element.select_one("div.list_img > a").attrs['href']
        detail_page_url_list.append(url)

    # get goods name and image url from each detail page
    ranking_num = 1
    for url in detail_page_url_list:
        req = Request(detail_page_url_list[0], headers={"User-Agent" : "Mozilla/5.9"})
        html = urlopen(req).read()
        soup = BeautifulSoup(html, "html.parser")

        goods_info = soup.select_one("div.product-img > img")
        goods_name = goods_info.attrs["alt"]
        goods_img_url = goods_info.attrs["src"]

        # upload img as "ranking_num.jpg" in s3
        urlretrieve("https:" + goods_img_url, "/tmp/temp_img.jpg")
        s3.upload_file("/tmp/temp_img.jpg", "application-serving-img", f"musinsa-crawled-img/top/{ranking_num}.jpg")
        
        #### write s3 img path, goods name, goods, detail_page_url in DB
        ### TO-DO

        ranking_num += 1

def lambda_handler(event, context):
    crawl_image()