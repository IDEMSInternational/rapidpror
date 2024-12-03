---
title: 'rapidpror: An R package for importing data from RapidPro into R'
tags:
  - R
  - rapidpro
  - mobile communication
  - chatbots
  - importing data
  - data analysis
authors:
  - name: Lily Clements
    orcid: 0000-0001-8864-0552
    equal-contrib: true
    affiliation: "1"
  - name: Chiara Facciola
    orcid: 0000-0001-8359-9300
    equal-contrib: true
    affiliation: "1"
  - name: David Stern
    equal-contrib: true
    affiliation: "1"
affiliations:
 - name: IDEMS International
   index: 1
date: 28 May 2024
bibliography: paper.bib

---

# Summary
This article introduces `rapidpror`, an R package developed to integrate with RapidPro, a platform developed in conjunction with UNICEF for creating mobile-based messaging systems like chatbots [@rapidpro]. RapidPro, particularly beneficial in low-connectivity or crisis-affected areas, supports various activities including social and behavioural change communication, and data collection across humanitarian and developmental sectors [@about_rapidpro].

The `rapidpror` package simplifies the process of importing chatbot data from RapidPro into the R environment. It incorporates filtering methods and automatic data frame linking to help enhance the data analysis process. This functionality serves to broaden the accessibility of data analysis, catering to users at various levels of R proficiency to help promote efficient research.

# Statement of need
RapidPro is a free, open-source platform designed to create and manage mobile-based messaging systems, such as chatbots [@rapidpro]. This tool is instrumental in facilitating social and behavioural change communication (SBCC) and data collection across various humanitarian and developmental contexts [@unicef2020global]. By enabling operations in regions with limited internet connectivity, RapidPro is particularly valuable in underserved or crisis-affected areas providing real-time information on activities such as health, education, and child-protection [@about_rapidpro].

In this article, we present `rapidpror`, an R package that allows for chatbot data to be efficiently and easily imported from RapidPro into R. This is achieved by incorporating advanced filtering mechanisms and automatic linking of different data frames obtained from RapidPro. `rapidpror` caters to users with varying levels of experience in R.

By simplifying the data import process through `rapidpror`, users can engage more deeply with the insights provided by chatbot data. This can empower researchers to make informed decisions and interventions. This capability is particularly relevant for researchers where timely and efficient data analysis can drive impactful outcomes. 

`rapidpror` is positioned within the broader context of computational tools for data-driven research, offering a direct, simplified channel between the chatbot data received by RapidPro, and statistical analysis tools in R.


# Our explicit need

The `rapidpror` package was driven by our collaboration with Parenting for Lifelong Health (PLH) [@PLH2023], where we have been intimately engaged with researchers in developing a suite of chatbots that prevent family violence. These chatbots are developed using RapidPro.

With multiple deployments across different contexts, the need arose for a streamlined method to provide the chatbot data to researchers promptly and efficiently. This would allow our partners to be able to measure engagement with the chatbot, and get a live overview of the use of the chatbot. However, accessing data directly through the RapidPro interface posed significant challenges; for example, it is less flexible in tailoring outputs to meet our partner needs. In addition, we would require data cleaning and manipulation to get the chatbot data into a suitable format for our partners when looking at the data. In all, we wanted to create a pipeline that transferred data from RapidPro into a live dashboard. This pipeline would have to involve data cleaning and manipulation to prepare the data for comprehensive analysis and real-time monitoring of chatbot engagement.

R was a suitable platform for this. However, there was a lack of automation in transferring data directly from RapidPro into R. `rapidpror` was developed to bridge this gap. It automates the data import process, enabling users to perform multiple data retrieval operations from RapidPro with minimal effort. This functionality includes looping through various calls, such as multiple runs or flows, thus simplifying the user experience and enhancing the efficiency of importing data into R.


# Usage
The use of `rapidpror` begins by establishing a connection to RapidPro using the user's API credentials. This involves setting the API key and the RapidPro site URL with the following functions:

```
rapidpror::set_rapidpro_key(key = "YOUR_API_TOKEN_HERE")
rapidpror::set_rapidpro_site(site = "YOUR_RAPIDPRO_SITE_URL_HERE")
```

This stores the key and site, ensuring that subsequent calls to RapidPro use these credentials. RapidPro processes data at various levels. The primary focus is on user data and flow data:

- User Data: This includes information related to the users of the chatbot system. To retrieve this data, use `get_user_data()`.
- Flow Data: This refers to the data generated by interactions within the chatbot flows. To access this data, use `get_flow_data()`. You can specify whether to call all flows for a specific set of users, or whether to call specific flows. 
The package also allows access to RapidPro’s full suite of data through a more general function: `get_data_from_rapidpro_api()`. In this function, you can specify the call type to make. For example, `get_user_data()` is effectively running

```
get_data_from_rapidpro_api(call_type = "contacts.json")
```

# Data Integration
`rapidpror` is designed to facilitate robust data analysis by enabling seamless integration with R-Instat, an open-source front-end to R [@rinstat]. This integration allows for automatic linking of different data frames obtained from RapidPro, supporting comprehensive analysis across various levels of data. By facilitating data coherence and deeper insights, `rapidpror` can help researchers leverage the full potential of chatbot interactions for their studies.

# Future Work
While the current version of `rapidpror` facilitates the accessibility and usability of RapidPro data within R, we are committed to its continual improvement based on user feedback and emerging research needs. Future versions of the package will aim to support additional call-types from RapidPro as new use-cases are identified by our growing user community. Additionally, we plan to expand the capabilities of `rapidpror` to integrate RapidPro data with other tools and platforms, such as R-Instat.

Through these efforts, we aim to keep `rapidpror` at the forefront of data-driven research, continually adapting to the dynamic needs of its users and expanding its impact on the global research community.

# Acknowledgements
This study is part of the Global Parenting Initiative, which is funded by The LEGO Foundation, Oak Foundation, the World Childhood Foundation, The Human Safety Net, ELMA Philanthropies, and the UK Research and Innovation Global Challenges Research Fund (ES/S008101/1).

# References

