import { Request, Response } from 'express';
import BaseController from './base.controller';
import { PrismaClient } from '@prisma/client';
import { TestUserId } from '../config/test';
const validStatusValues = ['pending', 'complete', 'failed'];

const prisma = new PrismaClient();

export default class OrderController extends BaseController {
  constructor() {
    super();
  }

  async getOrder(req: Request, res: Response) {
    // Assuming you have the order ID from the request params
    const orderId = req.params.order_id; // Replace with your actual parameter name

    // Fetch the order details from the database using Prisma
    const order = await prisma.order.findFirst({
      where: {
        id: orderId,
      },
      include: {
        customer: true,
      },
    });

    if (!order) {
      return res.status(404).json({ error: 'Order not found' });
    }

    // Return the order data as part of the response
    this.success(
      res,
      '--product/updated',
      'product updated successfully',
      200,
      { data: order } // Include the order data in the response
    );
  }

  async getAllOrders(req: Request, res: Response) {
    //const userId = 
    const userId = "1";

    if (!userId) {
      return this.error(res, '--order/all', 'This user id does not exist', 400, 'user not found');
    }

    const { page = 1, pageSize = 10 } = req.query;
    const orders = await prisma.order_item.findMany({
      where: {
        merchant_id: userId,
      },
      select: {
        order_id: true,
        createdAt: true,
        merchant: {
          select: {
            customer_orders: {
              select: {
                status: true,
              },
            },
          },
        },
        customer: {
          select: {
            username: true,
          },
        },
        product: { // Add the product selection here
          select: {
            name: true,
          },
        },
      },
      skip: (+page - 1) * +pageSize,
      take: +pageSize,
    });

    if (!orders) {
      return this.error(res, '--order/all', 'An error occurred', 500, 'internal server error');
    }
    return this.success(res, '--order/all', 'Orders fetched successfully', 200, orders);
  }

  async getAverageOrderValue(req: Request, res: Response) {
    const timeframe = (req.query.timeframe as string)?.toLocaleLowerCase();
    const merchantUserId = (req as any).user['id'];

    if (!timeframe) {
      this.error(res, '--order/average', 'Missing timeframe parameter', 400);
      return;
    }

    if (timeframe !== 'today') {
      this.error(res, '--order/average', 'Invalid timeframe parameter', 400);
      return;
    }

    // Calculate the start and end timestamps for today
    const currentDate = new Date();

    const startOfDay = new Date(currentDate);
    startOfDay.setHours(0, 0, 0, 0);
    const endOfDay = new Date(currentDate);
    endOfDay.setHours(23, 59, 59, 999);


    const orderItems = await prisma.order_item.findMany({
      where: {
        merchant_id: merchantUserId,
        createdAt: {
          gte: startOfDay,
          lte: endOfDay,
        },
      },
    });


    const totalSales = orderItems.reduce((sum, item) => sum + item.order_price, 0);
    const averageSales = parseFloat((totalSales / orderItems.length).toFixed(2));

    this.success(res, '--order/average', 'Average order value for today fetched successfully', 200, {
      averageSales,
    });
  }

  async updateOrderStatus(req: Request, res: Response) {
    const userId = (req as any).user?.id ?? TestUserId;
    const orderId = req.params['order_id'];
    const newStatus = req.body.status;

    // Check if the order exists
    if (!newStatus || newStatus.trim() === '') {
      return this.error(res, '--order/status', 'Status cannot be empty', 400);
    }
    const existingOrder = await prisma.order.findFirst({
      where: {
        id: orderId,
      },
    });

    if (!existingOrder) {
      return this.error(res, '--order/status', 'Order not found', 404);
    }

    if (!validStatusValues.includes(newStatus)) {
      return this.error(res, '--order/status', 'Invalid status value', 400);
    }

    // Find the order item that matches the merchant and order
    const orderItem = await prisma.order_item.findFirst({
      where: {
        merchant_id: userId,
        order_id: orderId,
      },
    });

    if (!orderItem) {
      return this.error(res, '--order/status', 'Order item not found for the merchant and order', 404);
    }
    const updatedOrder = await prisma.order.update({
      where: {
        id: orderId,
      },
      data: {
        status: newStatus,
      },
    });

    this.success(res, '--order/status', 'Order status updated successfully', 200, { data: updatedOrder });
  }
}