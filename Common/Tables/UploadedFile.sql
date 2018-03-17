SELECT * FROM UPLOADEDFILES (NOLOCK)

SELECT * FROM SYSTEMINFO WHERE KEYWORD  = 'Image_Storage_Path'
--UPDATE SYSTEMINFO SET KEYWORDVALUE = '\\WL00070239\filedata' WHERE KEYWORD = 'Image_Storage_Path' --\\active.tan\data\an_filedata\Marana
SELECT * FROM SYSTEMINFO WHERE KEYWORD  = 'file_upload_limit'
SELECT * FROM SYSTEMINFO WHERE KEYWORD LIKE 'uploaded_file_limit%'

--allow_upload_content_types: firstly retrive from
SELECT * FROM ACTIVENETSITES.DBO.SYSTEMINFO WHERE KEYWORD = 'allow_upload_content_types'
--then, String[][] default_global_system_info_values = {...} in SystemInfo.java

--writefiledata: sdi.ini
--writefiledata=/opt/active/data/an_filedata/linux01

--ActiveNetFolder
SELECT * FROM ACTIVENETSITES.DBO.SYSTEMINFO WHERE KEYWORD = 'AttachmentFolder'