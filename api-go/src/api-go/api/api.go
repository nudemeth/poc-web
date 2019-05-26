package api

import (
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"net/url"
	"strings"
)

type CatalogService interface {
	GetCatalog(url string, userAgent string) ([]byte, error)
}

type IdentityService interface {
	GetIdentity(url string, userAgent string) ([]byte, error)
	GetIdentityToken(url string) ([]byte, error)
	GetIdentityUserInfo(url string, token string) ([]byte, error)
	CreateIdentityUserInfo(requestUrl string, issuer string, token string, login string) (int, error)
}

type Service struct {
	Client  *http.Client
	BaseURL string
}

func (service *Service) GetCatalog(url string, userAgent string) ([]byte, error) {
	req, err := http.NewRequest("GET", service.BaseURL+url, nil)
	req.Header.Add("User-Agent", userAgent)

	if err != nil {
		log.Printf("Error occur when creating request: service=%s, URI=%s\n%s", "Catalog", url, err.Error())
		return nil, err
	}

	res, err := service.Client.Do(req)

	if err != nil {
		log.Printf("Error occur when requesting: service=%s, URI=%s\n%s", "Catalog", url, err.Error())
		return nil, err
	}

	defer res.Body.Close()

	log.Printf("Redirect to: service=%s, URI=%s", "Catalog", url)
	body, err := ioutil.ReadAll(res.Body)

	if err != nil {
		log.Printf("Error occur when reading response: service=%s, URI=%s\n%s", "Catalog", url, err.Error())
		return nil, err
	}

	return body, nil
}

func (service *Service) GetIdentity(url string, header http.Header) ([]byte, error) {
	req, err := http.NewRequest("GET", service.BaseURL+url, nil)
	req.Header = header

	if err != nil {
		log.Printf("Error occur when creating request: service=%s, URI=%s\n%s", "Identity", url, err.Error())
		return nil, err
	}

	res, err := service.Client.Do(req)

	if err != nil {
		log.Printf("Error occur when requesting: service=%s, URI=%s\n%s", "Identity", url, err.Error())
		return nil, err
	}

	defer res.Body.Close()

	log.Printf("Redirect to: service=%s, URI=%s", "Identity", url)
	body, err := ioutil.ReadAll(res.Body)

	if err != nil {
		log.Printf("Error occur when reading response: service=%s, URI=%s\n%s", "Identity", url, err.Error())
		return nil, err
	}

	return body, nil
}

func (service *Service) GetIdentityToken(url string) ([]byte, error) {
	req, err := http.NewRequest("POST", url, nil)
	req.Header.Add("Accept", "application/json")

	if err != nil {
		log.Printf("Error occur when creating request: service=%s, URI=%s\n%s", "Identity", url, err.Error())
		return nil, err
	}

	res, err := service.Client.Do(req)

	if err != nil {
		log.Printf("Error occur when requesting: service=%s, URI=%s\n%s", "Identity", url, err.Error())
		return nil, err
	}

	defer res.Body.Close()

	log.Printf("Redirect to: service=%s, URI=%s", "Identity", url)
	body, err := ioutil.ReadAll(res.Body)

	if err != nil {
		log.Printf("Error occur when reading response: service=%s, URI=%s\n%s", "Identity", url, err.Error())
		return nil, err
	}

	return body, nil
}

func (service *Service) GetIdentityUserInfo(url string, token string) ([]byte, error) {
	req, err := http.NewRequest("GET", url, nil)
	req.Header.Add("Accept", "application/json")
	req.Header.Add("Authorization", fmt.Sprintf("token %s", token))
	req.Header.Add("User-Agent", "poc-microservice-dev")

	if err != nil {
		log.Printf("Error occur when creating request: service=%s, URI=%s\n%s", "Identity", url, err.Error())
		return nil, err
	}

	res, err := service.Client.Do(req)

	if err != nil {
		log.Printf("Error occur when requesting: service=%s, URI=%s\n%s", "Identity", url, err.Error())
		return nil, err
	}

	defer res.Body.Close()

	log.Printf("Redirect to: service=%s, URI=%s", "Identity", url)
	body, err := ioutil.ReadAll(res.Body)

	if err != nil {
		log.Printf("Error occur when requesting: service=%s, URI=%s\n%s", "Identity", url, err.Error())
		return nil, err
	}

	return body, nil
}

func (service *Service) CreateIdentityUserInfo(requestUrl string, issuer string, token string, login string) (int, error) {
	data := url.Values{}
	data.Set("issuer", issuer)
	data.Set("token", token)
	data.Set("login", login)
	dataReader := strings.NewReader(data.Encode())

	req, err := http.NewRequest("POST", requestUrl, dataReader)
	req.Header.Add("Accept", "application/json;charset=UTF-8")

	if err != nil {
		log.Printf("Error occur when creating request: service=%s, URI=%s\n%s", "Identity", requestUrl, err.Error())
		return 500, err
	}

	res, err := service.Client.Do(req)

	if err != nil {
		log.Printf("Error occur when requesting: service=%s, URI=%s\n%s", "Identity", requestUrl, err.Error())
		return 500, err
	}

	log.Printf("Status: service=%s, URI=%s, code=%d", "Identity", requestUrl, res.StatusCode)
	code := res.StatusCode

	if err != nil {
		log.Printf("Error occur when requesting: service=%s, URI=%s\n%s", "Identity", requestUrl, err.Error())
		return 500, err
	}

	return code, nil
}
