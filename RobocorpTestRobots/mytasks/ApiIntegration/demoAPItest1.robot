*** Settings ***
Library     RPA.HTTP
*** Variables ***
${base_url}     https://reqres.in
${user_id}  2
${update_data}      {"name": "Favas","job": "SE"}

*** Tasks ***
Get Single Employee Detail
    create session      mysession   ${base_url}
    ${response}     get request       mysession   /api/users?page=2
    log to console  ${response.status_code}
    log to console  ${response.text}
    # log to console  ${response.headers}
    # log to console  ${response.json()}
    # log to console  ${response.json()['data']['id']}
    # log to console  ${response.json()['data']['first_name']}
    # log to console  ${response.json()['data']['last_name']}
 

# Update Record Single Id
#     create session      mysession   ${base_url}
#     ${response}     put request     mysession    ${base_url}/api/users/${user_id}     data=${update_data}   
#     Should Be Equal As Strings    ${response.status_code}    200  
#     log to console  ${response.status_code}
#     log to console  ${response}
#     log to console  ${response.json()}
    