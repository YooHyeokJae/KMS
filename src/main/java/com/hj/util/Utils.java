package com.hj.util;

import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.DateUtil;
import org.json.JSONArray;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.text.SimpleDateFormat;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class Utils {
    static Logger log = LoggerFactory.getLogger(Utils.class);

    public static String getCellValueAsString(Cell cell) {
        if (cell == null) return "N/A";
        switch (cell.getCellType()) {
            case STRING:
                return cell.getStringCellValue();
            case NUMERIC:
                if (DateUtil.isCellDateFormatted(cell)) {
                    return new SimpleDateFormat("yyyy-MM-dd").format(cell.getDateCellValue());
                }
                return String.valueOf((int) cell.getNumericCellValue());
            case BOOLEAN:
                return String.valueOf(cell.getBooleanCellValue());
            default:
                return "N/A";
        }
    }

    public static Map<String, Object> getIpInfo() {
        Map<String, Object> result = new HashMap<>();
        try {
            URL url = new URL("http://ipinfo.io/json");
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            BufferedReader reader = new BufferedReader(new InputStreamReader(connection.getInputStream()));

            StringBuilder response = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                response.append(line);
            }
            reader.close();

            JSONObject jsonResponse = new JSONObject(response.toString());
            result.put("ip", jsonResponse.getString("ip"));
            result.put("city", jsonResponse.getString("city"));
            result.put("region", jsonResponse.getString("region"));
            result.put("country", jsonResponse.getString("country"));
            result.put("loc", jsonResponse.getString("loc"));
            result.put("timezone", jsonResponse.getString("timezone"));
        } catch (Exception e) {
            log.error(e.getMessage());
        }
        return result;
    }

    public static Map<String, Object> getWeather(String nx, String ny) throws Exception {
        Map<String, Object> result = new HashMap<>();

        LocalDateTime now = LocalDateTime.now();
        DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("yyyyMMdd");
        DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HHmm");
        String currentTime = now.format(timeFormatter);
        String[] times = {"0200", "0500", "0800", "1100", "1400", "1700", "2000", "2300"};

        String baseDate = now.format(dateFormatter);
        String baseTime = null;
        for(String time : times) {
            if(time.compareTo(currentTime) <= 0) {
                if (baseTime == null || time.compareTo(baseTime) > 0) {
                    baseTime = time;
                }
            }
        }
        if(baseTime == null){
            baseDate = now.minusDays(1).format(dateFormatter);
            baseTime = "2300";
        }

        String type = "json";

        String apiUrl = "http://apis.data.go.kr/1360000/VilageFcstInfoService_2.0/getVilageFcst";
        String serviceKey = "G2y75Di8bdmLYfzEcTipliAnnol46wa9ak4fSOKJjmGdd%2BS%2F5%2F0C482bCLZZJXuJ1q9Vxvb3vwmaAqiqTq%2FlrA%3D%3D";

        String urlStr = apiUrl + "?" + URLEncoder.encode("ServiceKey", "UTF-8") + "=" + serviceKey +
                "&" + URLEncoder.encode("nx", "UTF-8") + "=" + URLEncoder.encode(nx, "UTF-8") +
                "&" + URLEncoder.encode("ny", "UTF-8") + "=" + URLEncoder.encode(ny, "UTF-8") +
                "&" + URLEncoder.encode("base_date", "UTF-8") + "=" + URLEncoder.encode(baseDate, "UTF-8") +
                "&" + URLEncoder.encode("base_time", "UTF-8") + "=" + URLEncoder.encode(baseTime, "UTF-8") +
                "&" + URLEncoder.encode("dataType", "UTF-8") + "=" + URLEncoder.encode(type, "UTF-8");
        ;

        URL url = new URL(urlStr);

        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/json");

        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
            rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), StandardCharsets.UTF_8));
        } else {
            rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), StandardCharsets.UTF_8));
        }

        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }

        rd.close();
        conn.disconnect();

        try {
            JSONObject jsonObj = new JSONObject(sb.toString());
            JSONObject response = jsonObj.getJSONObject("response");    // response 키를 가지고 데이터를 파싱
            JSONObject body = response.getJSONObject("body");           // response 로 부터 body 찾기
            JSONObject items = body.getJSONObject("items");               // body 로 부터 items 찾기
            JSONArray itemArray = items.getJSONArray("item");
            for (int i = 0; i < itemArray.length(); i++) {                            // items 로 부터 결과 Map 만들기
                JSONObject item = itemArray.getJSONObject(i);
                String category = item.getString("category");
                String fcstValue = item.getString("fcstValue");
                result.put(category, fcstValue);
            }
        }catch(Exception e) {
            log.error(e.getMessage());
            result.put("error", e.getMessage());
        }
        return result;
    }
}
