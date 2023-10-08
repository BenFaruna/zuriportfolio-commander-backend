import App from "./app";
import UserRoute from "./routes/user.route";
import RevenueRoute from "./routes/revenew.route";
import OrderRoute from './routes/order.route';
import ProductRoute from 'routes/product.Route';


const server = new App();
server.initializedRoutes([new UserRoute(), new OrderRoute(), new ProductRoute(),  new RevenueRoute()]);
server.listen();
