# resume-files
This project contains code files and snapshots related to projects mentioned in my resume

Virtual Machine: Created a VM (Honeypot) with all ports open to make it more enticing for attackers.

![image](https://user-images.githubusercontent.com/113646254/195236210-28f2f807-04eb-46ee-b849-b0cc6f4a63ff.png)

Log Analytics Workspace: Created a custom log and custom fields to get more information needed for the final failed login attempts map.

![image](https://user-images.githubusercontent.com/113646254/195234188-4a776c39-7563-4364-aa81-31778faa1631.png)

Microsoft Sentinel Query for Map: Created a new query to select for specific fields in custom log to be used in the Failed Login attempts map.

Query ---> FAILED_RDP_WITH_GEO_CL | summarize event_count=count() by Sourcehost_CF, Latitude_CF, Longitude_CF, Country_CF, Label_CF, Destinationhost_CF | where Destinationhost_CF != "samplehost" | where Sourcehost_CF != ""

![image](https://user-images.githubusercontent.com/113646254/195234940-ee1f9e30-833b-408e-ad48-73d400005820.png)

Failed RDP World Map: Final result of Map within the first 24hrs.

![image](https://user-images.githubusercontent.com/113646254/195235017-a160064a-680b-4072-917f-9dada5675a4d.png)

